// floating point for neural networks
// no denorm no NAN or inf or rounding

// define the type of stage logic
`ifndef __MULT_TYPES
   `define __MULT_TYPES
   `define COMBINATORIAL always_comb
   `define REGISTERED always_ff @ (posedge clock)

   // set the stages
   `define MULT_STAGE1 `REGISTERED
   `define MULT_STAGE2 `REGISTERED
`endif

module fp_mlt # (
            parameter            EXP = 8,
            parameter            MANT = 7,
            parameter            WIDTH = 1 + EXP + MANT,
            parameter            LCYCLES = 2
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   input    logic                data_valid,
   input    logic [WIDTH-1:0]    dataa,
   input    logic [WIDTH-1:0]    datab,
   output   logic                result_valid,
   output   logic [WIDTH-1:0]    result
);
            localparam           MANT2 = (MANT + 1) * 2;
            localparam           BIAS = (2 ** (EXP - 1)) - 1;
            logic [EXP-1:0]      ae, be, re;
            logic [MANT2-1:0]    mult;
            logic [WIDTH-1:0]    r;
            logic                as, bs, rs, a_zero, b_zero, valid;
            wire [EXP:0]         ex = ({1'b0, ae} + {1'b0, be} - BIAS[EXP:0]);

   `MULT_STAGE1 begin
      a_zero <= ~|dataa[WIDTH-2:0];
      b_zero <= ~|datab[WIDTH-2:0];
      mult <= {1'b1, dataa[MANT-1:0]} * {1'b1, datab[MANT-1:0]};
      {as, ae} <= dataa[WIDTH-1:MANT];
      {bs, be} <= datab[WIDTH-1:MANT];
      valid <= data_valid & ~clock_sreset;
   end

   `MULT_STAGE2 begin
      if (a_zero | b_zero) begin
         result <= {WIDTH{1'b0}};
      end
      else begin
         result[WIDTH-1] <= as ^ bs;
         result[WIDTH-2:MANT] <= ex[EXP-1:0];
         if (mult[MANT2-1])
            result[MANT-1:0] <= mult[MANT2-2:MANT2-MANT-1];
         else
            result[MANT-1:0] <= mult[MANT2-3:MANT2-MANT-2];
      end
      result_valid <= valid & ~clock_sreset;
   end
      
endmodule
