module fp_add_tree # (
            parameter                     EXP = 8,
            parameter                     MANT = 8,
            parameter                     ITEMS = 9,
            parameter                     LCYCLES = 4,
            parameter                     WIDTH = 1 + EXP + MANT
)
(
   input    logic                         clock,
   input    logic                         clock_sreset,
   input    logic                         data_valid,
   input    logic [ITEMS-1:0][WIDTH-1:0]  dataa,
   output   logic                         result_valid,
   output   logic [WIDTH-1:0]             result
);
            localparam                    HALF = (ITEMS / 2);
            localparam                    WIDTHH = (ITEMS - HALF);
            localparam                    ZERO = {WIDTH{1'b0}};
   generate
      begin
         if (ITEMS == 1) begin   // only one branch? - keep latency balanced
            fp_latency                    # (
                                             .EXP(EXP),
                                             .MANT(MANT),
                                             .LCYCLES(LCYCLES * 2)
                                          )
                                          addera (
                                             .clock(clock),
                                             .clock_sreset(clock_sreset),
                                             .data_valid(data_valid),
                                             .dataa(dataa[0]),
                                             .result_valid(result_valid),
                                             .result(result)
                                          );
         end
         if (ITEMS == 2) begin   // two branches - keep latency balanced
            logic [WIDTH-1:0]             result_a;
            logic                         resulta_valid;
            fp_add                        # (
                                             .EXP(EXP),
                                             .MANT(MANT),
                                             .LCYCLES(LCYCLES)
                                          )
                                          addera (
                                             .clock(clock),
                                             .clock_sreset(clock_sreset),
                                             .data_valid(data_valid),
                                             .dataa(dataa[0]),
                                             .datab(dataa[1]),
                                             .result_valid(resulta_valid),
                                             .result(result_a)
                                          );
            fp_latency                    # (
                                             .EXP(EXP),
                                             .MANT(MANT),
                                             .LCYCLES(LCYCLES)
                                          )
                                          adderb (
                                             .clock(clock),
                                             .clock_sreset(clock_sreset),
                                             .dataa(result_a),
                                             .data_valid(resulta_valid),
                                             .result_valid(result_valid),
                                             .result(result)
                                          );
         end
         if (ITEMS > 2) begin // keep halving the tree
            logic [WIDTH-1:0]             result_a, result_b;
            logic                         resulta_valid;
            fp_add_tree                   # (
                                             .EXP(EXP),
                                             .MANT(MANT),
                                             .ITEMS(HALF),
                                             .LCYCLES(LCYCLES)
                                          )
                                          addera (
                                             .clock(clock),
                                             .clock_sreset(clock_sreset),
                                             .data_valid(data_valid),
                                             .dataa(dataa[ITEMS-1:WIDTHH]),
                                             .result_valid(resulta_valid),
                                             .result(result_a)
                                          );
            fp_add_tree                   # (
                                             .EXP(EXP),
                                             .MANT(MANT),
                                             .ITEMS(WIDTHH),
                                             .LCYCLES(LCYCLES)
                                          )
                                          adderb (
                                             .clock(clock),
                                             .clock_sreset(clock_sreset),
                                             .data_valid(),
                                             .dataa(dataa[WIDTHH-1:0]),
                                             .result_valid(),
                                             .result(result_b)
                                          );
            fp_add                        # (
                                             .EXP(EXP),
                                             .MANT(MANT),
                                             .LCYCLES(LCYCLES)
                                          )
                                          adderc (
                                             .clock(clock),
                                             .clock_sreset(clock_sreset),
                                             .data_valid(resulta_valid),
                                             .dataa(result_a),
                                             .datab(result_b),
                                             .result_valid(result_valid),
                                             .result(result)
                                          );
         end
      end
   endgenerate

endmodule
