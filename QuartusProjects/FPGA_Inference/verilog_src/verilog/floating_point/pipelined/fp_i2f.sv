// floating point for neural networks
// no denorm no NAN or inf or rouding

// define the type of stage logic
`ifndef __I2F_TYPES
   `define __I2F_TYPES
   `define COMBINATORIAL always_comb
   `define REGISTERED always_ff @ (posedge clock)

   // set the stages
   `define I2F_STAGE1 `REGISTERED
   `define I2F_STAGE2 `REGISTERED
`endif
module fp_i2f # (
            parameter            EXP = 8,
            parameter            MANT = 23,
            parameter            WIDTH = 1 + EXP + MANT
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   input    logic [MANT:0]       dataa,
   input    logic                data_valid,
   output   logic [WIDTH-1:0]    result,
   output   logic                result_valid
);
            localparam           ZERO = {WIDTH*2{1'b0}};
            localparam           ONE = {ZERO, 1'b1};
            localparam           BIAS = (2 ** (EXP - 1)) - 1;
            integer              i;
            logic [0:0]          valid;
            logic [EXP-1:0]      zeroes, msone;
            logic [MANT:0]       abs_dataa;
            logic                sign;

   `I2F_STAGE1 begin
      sign <= dataa[MANT];
      abs_dataa <= dataa[MANT] ? (~dataa + ONE[MANT:0]) : dataa;
      valid[0] <= data_valid & ~clock_sreset;
   end
   
   always_comb begin
      zeroes = ZERO[EXP-1:0];
      msone = ZERO[EXP-1:0];
      for (i=MANT; i>=0; i--)
         if (abs_dataa[i]) begin
            msone = i[EXP-1:0];
            zeroes = MANT[EXP-1:0] - i[EXP-1:0];
            break;
         end
   end

   `I2F_STAGE2 begin
      result_valid <= valid[0] & ~clock_sreset;
      if (~|abs_dataa)
         result <= ZERO[WIDTH-1:0];
      else begin
         result[WIDTH-1] <= sign;
         result[WIDTH-2:MANT] <= BIAS[EXP-1:0] + msone;
         result[MANT-1:0] <= abs_dataa[MANT-1:0] << zeroes;
      end
   end
   
endmodule
