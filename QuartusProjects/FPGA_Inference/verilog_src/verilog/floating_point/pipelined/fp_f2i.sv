// floating point for neural networks
// no denorm no NAN or inf or rouding

// define the type of stage logic
`ifndef __F2I_TYPES
   `define __F2I_TYPES
   `define COMBINATORIAL always_comb
   `define REGISTERED always_ff @ (posedge clock)

   // set the stages
   `define F2I_STAGE1 `REGISTERED
   `define F2I_STAGE2 `REGISTERED
`endif
module fp_f2i # (
            parameter            EXP = 8,
            parameter            MANT = 23,
            parameter            WIDTH = 1 + EXP + MANT
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   input    logic [WIDTH-1:0]    dataa,
   input    logic                data_valid,
   output   logic [MANT:0]       result,
   output   logic                result_valid
);
            localparam           ZERO = {WIDTH*2{1'b0}};
            localparam           ONE = {ZERO, 1'b1};
            localparam           BIAS = (2 ** (EXP - 1)) - 1;
            integer              i;
            logic [0:0]          valid;
            logic                sign;
            wire                 dataa_zero = ~|dataa[WIDTH-2:0];
            logic [EXP-1:0]      exponent;
            logic [MANT:0]       mantissa;
            
   `F2I_STAGE1 begin
      sign <= dataa[WIDTH-1] & ~dataa_zero;
      mantissa <= dataa_zero ? ZERO[MANT:0] : ({1'b1, dataa[MANT-1:0]}) >> (dataa[WIDTH-2:MANT] - BIAS);
      valid[0] <= data_valid & ~clock_sreset;
   end
   
   `F2I_STAGE2 begin
      result_valid <= valid[0] & ~clock_sreset;
      result <= sign ? (~mantissa + ONE[MANT:0]) : mantissa;
   end
   
endmodule
