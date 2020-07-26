// floating point for neural networks
// no denorm no NAN or inf or rouding

// define the type of stage logic
`ifndef __ADD_TYPES
   `define __ADD_TYPES
   `define COMBINATORIAL always_comb
   `define REGISTERED always_ff @ (posedge clock)

   // set the stages
   `define AGB_STAGE1 `REGISTERED
`endif

module fp_relu # (
            parameter            EXP = 4,
            parameter            MANT = 4,
            parameter            WIDTH = 1 + EXP + MANT
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   input    logic                data_valid,
   input    logic [WIDTH-1:0]    dataa,
   output   logic                result_valid,
   output   logic [WIDTH-1:0]    result,
);
            localparam           DONTCARE = {WIDTH*2{1'bx}};
            localparam           ZERO = {WIDTH*2{1'b0}};
            localparam           ONE = {ZERO, 1'b1};
            localparam           BIAS = (2 ** (EXP - 1)) - 1;
   
   fp_max   # (
               .EXP(EXP),
               .MANT(MANT)
            )
            max (
               .clock(clock),
               .clock_sreset(clock_sreset),
               .data_valid(data_valid),
               .dataa(dataa),
               .datab(ZERO[WIDTH-1:0]),
               .result_valid(result_valid),
               .result(result),
               .agb()
            );

endmodule
