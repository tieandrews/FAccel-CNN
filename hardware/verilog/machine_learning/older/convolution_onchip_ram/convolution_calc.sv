module convolution_calc # (
            parameter                   MAX_XRES = 128,
            parameter                   XRES1 = 16, XRES2 = 32, XRES3 = 64,
            parameter                   XRES4 = 4, XRES5 = 8,   // x resolution
            parameter                   RESOLUTIONS = 5,
            parameter                   K = 3,
            parameter                   EXP = 8,
            parameter                   MANT = 7,
            parameter                   WIDTH = 1 + EXP + MANT,
            parameter                   EXTRA_PIPELINE = 1
)
(
    input   logic                       clock,
    input   logic                       clock_sreset,
    
    input   logic [2:0]                 xres_select,
    
    input   logic                       kernel_data_shift,
    input   logic [WIDTH-1:0]           kernel_data,
    output  logic [WIDTH-1:0]           kernel_out,
    
    input   logic                       enable_calc,
    input   logic                       data_shift,
    input   logic [WIDTH-1:0]           data,
    
    output  logic                       result_valid,
    output  logic [WIDTH-1:0]           result
);
            localparam                  DONTCARE = {WIDTH{1'bx}};
            localparam                  ZERO = {WIDTH{1'b0}};
            localparam                  ONE = {ZERO, 1'b1};
            localparam                  WIDTHI = 2**$clog2(K*K);  // find closest power of 2 width
            
            integer                     x, y, t, xx, yy, ax, ay;
            
            logic [K*K-1:0][WIDTH-1:0]  kernel;
            logic [WIDTH-1:0]           buffer[MAX_XRES-1:0][K-1:0];
            logic [K-1:0][WIDTH-1:0]    buffer_taps[RESOLUTIONS-1:0];
            logic [K*K-1:0][WIDTH-1:0]  buffer_node;
            
    // handle kernel stream
    always_ff @ (posedge clock) begin
        if (kernel_data_shift) begin
            for (xx=0; xx<(K*K); xx++) begin
                if (xx == 0) begin
                    kernel[xx] <= kernel_data;
                end
                else begin
                    kernel[xx] <= kernel[xx-1];
                end
            end
        end
    end
    
    always_comb begin
        for (ay=0; ay<K; ay++) begin
            for (ax=0; ax<K; ax++) begin
                buffer_node[ax+(ay*K)] = buffer[ax][ay];
            end
        end
    end

    // generate buffer taps for X resolutions
    always_comb begin
        for (yy=0; yy<K; yy++) begin
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
            for (y=0; y<K; y++) begin
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
            sum_of_products # (
                                .EXP(EXP),
                                .MANT(MANT),
                                .WIDTH(WIDTH),
                                .NUM(K*K),
                                .EXTRA_PIPELINE(EXTRA_PIPELINE)
                            )
                            sop1 (
                                .clock(clock),
                                .clock_sreset(clock_sreset),
                                .data_valid(enable_calc),
                                .dataa(kernel),
                                .datab(buffer_node),
                                .result_valid(result_valid),
                                .result(result)
                            );
        end
    endgenerate
endmodule
