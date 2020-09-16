module micro_constant # (
            parameter            CONSTANT = 1,
            parameter            WIDTH = 18
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   input    logic [3:0]          address,
   input    logic [WIDTH-1:0]    writedata,
   output   logic [WIDTH-1:0]    readdata,
   input    logic                read,
   input    logic                write,
   output   logic                waitrequest
);

   always_comb begin
      waitrequest = 1'b0;
      readdata = CONSTANT[WIDTH-1:0];
   end

endmodule
