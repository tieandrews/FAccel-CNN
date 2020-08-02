module fp_max_tree # (
            parameter                     EXP = 8,
            parameter                     MANT = 7,
            parameter                     ITEMS = 9,
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
            logic [WIDTH-1:0]             result_a, result_b;
            logic                         resulta_valid;
   generate
      begin
         if (ITEMS == 1) begin
            fp_max # (.EXP(EXP), .MANT(MANT)) agb_a (.clock(clock), .clock_sreset(clock_sreset), .data_valid(data_valid),
               .dataa(dataa[0]), .datab(dataa[0]), .result_valid(resulta_valid), .result(result_a), .agb());
            fp_max # (.EXP(EXP), .MANT(MANT)) agb_b (.clock(clock), .clock_sreset(clock_sreset), .data_valid(),
               .dataa(dataa[0]), .datab(dataa[0]), .result_valid(), .result(result_b), .agb());
         end
         if (ITEMS == 2) begin
            fp_max # (.EXP(EXP), .MANT(MANT)) agb_a (.clock(clock), .clock_sreset(clock_sreset), .data_valid(data_valid),
               .dataa(dataa[0]), .datab(dataa[0]), .result_valid(resulta_valid), .result(result_a), .agb());
            fp_max # (.EXP(EXP), .MANT(MANT)) agb_b (.clock(clock), .clock_sreset(clock_sreset), .data_valid(data_valid),
               .dataa(dataa[1]), .datab(dataa[1]), .result(result_b), .agb());
         end
         if (ITEMS > 2) begin
            fp_max_tree # (.EXP(EXP), .MANT(MANT), .ITEMS(HALF)) agb_a (.clock(clock), .clock_sreset(clock_sreset), .data_valid(data_valid),
               .dataa(dataa[ITEMS-1:WIDTHH]), .result_valid(resulta_valid), .result(result_a));
            fp_max_tree # (.EXP(EXP), .MANT(MANT), .ITEMS(WIDTHH)) agb_b (.clock(clock), .clock_sreset(clock_sreset), .data_valid(),
               .dataa(dataa[WIDTHH-1:0]), .result_valid(), .result(result_b));
         end
         fp_max # (.EXP(EXP), .MANT(MANT)) agb_c (.clock(clock), .clock_sreset(clock_sreset), .data_valid(resulta_valid),
            .dataa(result_a), .datab(result_b), .result_valid(result_valid), .result(result), .agb());
      end
   endgenerate

endmodule
