module sum_of_products # (
            parameter                       EXP = 8,
            parameter                       MANT = 7,
            parameter                       WIDTH = 1 + EXP + MANT,
            parameter                       NUM = 9,
            parameter                       ADDER_PIPELINE = 1
)
(
    input   logic                           clock,
    input   logic                           clock_sreset,
    input   logic                           data_valid,
    input   logic [NUM-1:0][WIDTH-1:0]      dataa,
    input   logic [NUM-1:0][WIDTH-1:0]      datab,
    output  logic                           result_valid,
    output  logic [WIDTH-1:0]               result
);
            localparam                      ITEMS = 2 ** $clog2(NUM);
            logic [ITEMS-1:0][WIDTH-1:0]    mult_result;
            logic [NUM-1:0]                 mult_result_valid;

    genvar x;
    generate
        begin
            if (ITEMS > NUM) begin
                always_comb begin
                    mult_result[ITEMS-1:NUM] = {WIDTH{1'b0}};
                end
            end
            for (x=0; x<NUM; x++) begin : mx
                fp_mlt                      # (
                                                .EXP(EXP),
                                                .MANT(MANT),
                                                .WIDTH(WIDTH)
                                            )
                                            mlt (
                                                .clock(clock),
                                                .clock_sreset(clock_sreset),
                                                .data_valid(data_valid),
                                                .dataa(dataa[x]),
                                                .datab(datab[x]),
                                                .result_valid(mult_result_valid[x]),
                                                .result(mult_result[x])
                                            );
            end
            fp_add_tree                     # (
                                                .EXP(EXP),
                                                .MANT(MANT),
                                                .WIDTH(WIDTH),
                                                .ITEMS(ITEMS), 
                                                .EXTRA_PIPELINE(ADDER_PIPELINE)
                                            )
                                            adder_tree (
                                                .clock(clock),
                                                .clock_sreset(clock_sreset),
                                                .data_valid(mult_result_valid[0]),
                                                .data(mult_result),
                                                .result_valid(result_valid),
                                                .result(result)
                                            );
        end
    endgenerate

endmodule
