module convolution_calc # (
            parameter           MAX_RES = 256,
            parameter integer   XRES1=16, XRES2=32, XRES3=64, XRES4=128, XRES5=256,   // x resolution + padding (1?)
            parameter           RESOLUTIONS = 5,
            parameter           KX = 3,
            parameter           KY = 3,
            parameter           EXP = 8,
            parameter           MANT = 7,
            parameter           WIDTH = 1 + EXP + MANT,
            parameter           ADDER_PIPELINE = 1
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    
    input   logic [2:0]         xres_select,
    
    input   logic               kernel_valid,
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
            
            logic [WIDTH-1:0]   kernel[KX-1:0][KY-1:0];
            logic [WIDTH-1:0]   buffer[MAX_RES-1:0][KY-1:0];
            logic [WIDTHI-1:0][WIDTH-1:0] add_items;
            logic [WIDTH-1:0]   buffer_taps[RESOLUTIONS-1:0][KY-2:0];
            logic [KX*KY-1:0]   mlt_valid;
            
    // handle kernel stream
    always_ff @ (posedge clock) begin
        if (kernel_valid) begin
            for (y=0; y<KY; y++) begin
                for (x=0; x<KX; x++) begin
                    if (x == 0) begin
                        if (y == 0) begin
                            kernel[x][y] <= kernel_data;
                        end
                        else begin
                            kernel[x][y] <= kernel[KX-1][y-1];
                        end
                    end
                    else begin
                        kernel[x][y] <= kernel[x-1][y];
                    end
                end
            end
        end
    end

    // generate buffer taps for X resolutions
    always_comb begin
        for (yy=0; yy<KY-1; yy++) begin
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
                for (x=0; x<MAX_RES; x++) begin
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
    genvar i,j;
    generate
        begin
            if (WIDTHI > (KX * KY)) begin
                always_comb begin
                    add_items[WIDTHI-1:(KX*KY)] = 1'b0;
                end
            end
            for (j=0; j<KY; j++) begin : my
                for (i=0; i<KX; i++) begin : mx
                    fp_mlt      # (
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTH)
                                )
                                mlt (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .data_valid(enable_calc),
                                    .dataa(kernel[KX-i-1][KY-j-1]),
                                    .datab(buffer[i][j]),
                                    .result_valid(mlt_valid[i+(j*KX)]),
                                    .result(add_items[i+(j*KX)])
                                );
                end
            end
        end
    endgenerate
    
    fp_add_tree                 # (
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTH),
                                    .ITEMS(WIDTHI), 
                                    .EXTRA_PIPELINE(ADDER_PIPELINE)
                                )
                                adder_tree (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .data_valid(mlt_valid[0]),
                                    .data(add_items),
                                    .result_valid(result_valid),
                                    .result(result)
                                );
    
endmodule
