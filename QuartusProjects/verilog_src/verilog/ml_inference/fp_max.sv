// floating point for neural networks
// no denorm no NAN or inf or rouding

// define the type of stage logic
`ifndef __ADD_TYPES
   `define __ADD_TYPES
   `define COMBINATORIAL always_comb
   `define REGISTERED always_ff @ (posedge clock)

   // set the stages
   `define MAX_STAGE1 `REGISTERED
`endif

module fp_max # (
            parameter            EXP = 4,
            parameter            MANT = 4,
            parameter            WIDTH = 1 + EXP + MANT
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   input    logic                data_valid,
   input    logic [WIDTH-1:0]    dataa,
   input    logic [WIDTH-1:0]    datab,
   output   logic                result_valid,
   output   logic [WIDTH-1:0]    result,
   output   logic                agb
);
            localparam           DONTCARE = {WIDTH*2{1'bx}};
            localparam           ZERO = {WIDTH*2{1'b0}};
            localparam           ONE = {ZERO, 1'b1};
            localparam           BIAS = (2 ** (EXP - 1)) - 1;
            logic                sa, sb;
            logic [EXP-1:0]      ea, eb;
            logic [MANT:0]       ma, mb;
            wire                 a_gt_b_exp = {sa, ea} > {sb, eb};
            wire                 a_eq_b_exp = {sa, ea} == {sb, eb};
            wire                 a_gt_b_mant = ma > mb;            

   always_comb begin
      {sa, ea, ma} = {dataa[WIDTH-1:MANT], 1'b1, dataa[MANT-1:0]};
      {sb, eb, mb} = {datab[WIDTH-1:MANT], 1'b1, datab[MANT-1:0]};
   end
   `MAX_STAGE1 begin
      agb <= (a_gt_b_exp) | (a_eq_b_exp & a_gt_b_mant);
      if ((a_gt_b_exp) | (a_eq_b_exp & a_gt_b_mant))
         result <= dataa;
      else
         result <= datab;
      result_valid <= data_valid & ~clock_sreset;
   end
            
endmodule
