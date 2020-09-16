module micro_outport # (
            parameter            WIDTHD = 1,
            parameter            RESET_STATE = 0
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   input    logic [3:0]          address,
   input    logic [WIDTHD-1:0]   writedata,
   output   logic [WIDTHD-1:0]   readdata,
   input    logic                read,
   input    logic                write,
   output   logic                waitrequest,
   
   output   logic [WIDTHD-1:0]   outport
);

   always_comb begin
      waitrequest = 1'b0;
      readdata = outport;
   end
   always_ff @ (posedge clock) begin
      if (clock_sreset) begin
         outport <= RESET_STATE[WIDTHD-1:0];
      end
      else begin
         if (address == 4'h0)
            if (write)
               outport <= writedata;
      end
   end

endmodule
