module convolution_calc # (
            parameter                   K = 3,
            parameter                   EXP = 8,
            parameter                   MANT = 7,
            parameter                   WIDTHF = 1 + EXP + MANT,
            parameter                   PIPELINE = 1
)
(
    input   logic                       clock,
    input   logic                       clock_sreset,
    
    input   logic                       kernel_data_shift,
    input   logic                       enable_calc,
    input   logic [WIDTHF-1:0]          kernel_in,
    output  logic [WIDTHF-1:0]          kernel_out,
    input   logic [K*K-1:0][WIDTHF-1:0] window,
    output  logic                       result_valid,
    output  logic [WIDTHF-1:0]          result
);
            localparam                  DONTCARE = {WIDTHF{1'bx}};
            localparam                  ZERO = {WIDTHF{1'b0}};
            localparam                  ONE = {ZERO, 1'b1};
            
            integer                     x, y, t, xx, yy, ax, ay;
            
            logic [K*K-1:0][WIDTHF-1:0] kernel;
            
    // handle kernel stream
    always_ff @ (posedge clock) begin
        if (kernel_data_shift) begin
            for (xx=0; xx<(K*K); xx++) begin
                if (xx == 0) begin
                    kernel[xx] <= kernel_in;
                end
                else begin
                    kernel[xx] <= kernel[xx-1];
                end
            end
        end
    end
    
    assign kernel_out = kernel[(K*K)-1];
        
    // handle computation
    genvar i,j,k;
    generate
        begin
            sum_of_products # (
                                .EXP(EXP),
                                .MANT(MANT),
                                .WIDTHF(WIDTHF),
                                .NUM(K*K),
                                .PIPELINE(PIPELINE)
                            )
                            sop1 (
                                .clock(clock),
                                .clock_sreset(clock_sreset),
                                .data_valid(enable_calc),
                                .dataa(kernel),
                                .datab(window),
                                .result_valid(result_valid),
                                .result(result)
                            );
        end
    endgenerate
endmodule
