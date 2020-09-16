module convolution_calc # (
            parameter           MAX_XRES = 256,
            parameter           XRES1 = 16, XRES2 = 32, XRES3 = 64,
            parameter           XRES4 = 128, XRES5 = 256,   // x resolution + padding (1?)
            parameter           RESOLUTIONS = 5,
            parameter           KX = 3,
            parameter           KY = 3,
            parameter           NUM_KERNELS = 24,
            parameter           EXP = 8,
            parameter           MANT = 7,
            parameter           WIDTH = 1 + EXP + MANT,
            parameter           ADDER_PIPELINE = 1
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    
    input   logic [2:0]         xres_select,
    
    input   logic               kernel_data_shift,
    input   logic [WIDTH-1:0]   kernel_data,
    
    input   logic               enable_calc,
    input   logic               data_shift,
    input   logic [WIDTH-1:0]   data,
    
    output  logic               result_valid,
    output  logic [WIDTH-1:0]   result
);
            localparam          DONTCARE = {WIDTH{1'bx}};
            localparam          ZERO = {WIDTH{1'b0}};
            localparam          ONE = {ZERO, 1'b1};
            localparam          WIDTHI = 2**$clog2(KX*KY);  // find closest power of 2 width
            
            integer             x, y, t, yy;
            
            logic [KX*KY-1:0][WIDTH-1:0]   kernel[NUM_KERNELS-1:0];
            logic [WIDTH-1:0]             buffer[MAX_XRES-1:0][KY-1:0];
            logic [RESOLUTIONS-1:0][KY-2:0][WIDTH-1:0]   buffer_taps;
            logic [KX*KY-1:0][WIDTH-1:0]    buffer_node;
            
    // handle kernel stream
    always_ff @ (posedge clock) begin
        if (kernel_data_shift) begin
            for (t=0; t<NUM_KERNELS; t++) begin
                for (y=0; y<KY; y++) begin
                    for (x=0; x<KX; x++) begin
                        if (x == 0) begin
                            if (y == 0) begin
                                if (t == 0) begin
                                    kernel[t][x+(y*KX)] <= kernel_data;
                                end
                                else begin
                                    kernel[t][x+(y*KX)] <= kernel[t-1][KX*KY-1];
                                end
                            end
                            else begin
                                kernel[t][x+(y*KX)] <= kernel[t][KX*(y-1)];
                            end
                        end
                        else begin
                            kernel[t][x+(y*KX)] <= kernel[t][(x-1)+(y*KX)];
                        end
                    end
                end
            end
        end
    end
    
    always_comb begin
        for (y=0; y<KY; y++) begin
            for (x=0; x<KX; x++) begin
                buffer_node[x+(y*KX)] = buffer[x][y];
            end
        end
    end

    // generate buffer taps for X resolutions
    always_comb begin
        for (yy=0; yy<(KY-1); yy++) begin
            for (t=0; t<RESOLUTIONS; t++) begin
                if (t == 0) buffer_taps[t][yy] = buffer[XRES1-1][yy];
                if (t == 1) buffer_taps[t][yy] = buffer[XRES2-1][yy];
                if (t == 2) buffer_taps[t][yy] = buffer[XRES3-1][yy];
                if (t == 3) buffer_taps[t][yy] = buffer[XRES4-1][yy];
                if (t == 4) buffer_taps[t][yy] = buffer[XRES5-1][yy];
            end
        end
    end
    always_ff @ (posedge clock) begin
        if (data_shift) begin
            for (y=0; y<KY; y++) begin
                for (x=0; x<MAX_XRES; x++) begin
                    if (x == 0) begin
                        if (y == 0) begin
                            buffer[x][y] <= data;
                        end
                        else begin
                            buffer[x][y] <= buffer_taps[xres_select][y-1];
                        end
                    end
                    else begin
                        buffer[x][y] <= buffer[x-1][y];
                    end
                end
            end
        end
    end
    
    // handle computation
    genvar i,j,k;
    generate
        begin
            if (NUM_KERNELS == 1) begin
                sum_of_products # (
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTH),
                                    .NUM(KX*KY),
                                    .ADDER_PIPELINE(ADDER_PIPELINE)
                                )
                                sop1 (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .data_valid(enable_calc),
                                    .dataa(kernel[0]),
                                    .datab(buffer_node),
                                    .result_valid(result_valid),
                                    .result(result)
                                );
            end
            else begin
                logic [NUM_KERNELS-1:0] sop_result_valid;
                logic [NUM_KERNELS-1:0][WIDTH-1:0] sop_result;
                for (i=0; i<NUM_KERNELS; i++) begin : index
                sum_of_products # (
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTH),
                                    .NUM(KX*KY),
                                    .ADDER_PIPELINE(ADDER_PIPELINE)
                                )
                                sop1 (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .data_valid(enable_calc),
                                    .dataa(kernel[i]),
                                    .datab(buffer_node),
                                    .result_valid(sop_result_valid[i]),
                                    .result(sop_result[i])
                                );
                end
                fp_add_tree     # (
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .ITEMS(2**$clog2(NUM_KERNELS)),
                                    .WIDTH(WIDTH),
                                    .EXTRA_PIPELINE(ADDER_PIPELINE)
                                )
                                (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .data_valid(sop_result_valid[0]),
                                    .data(sop_result),
                                    .result_valid(result_valid),
                                    .result(result)
                                );
            end
        end
    endgenerate
    
    
endmodule
