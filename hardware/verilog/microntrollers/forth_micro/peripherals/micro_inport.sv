module micro_inport # (
            parameter            WIDTHD = 1
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
   output   logic                irq,
   
   input    logic [WIDTHD-1:0]   inport
);
            logic                read_latency;
            logic [WIDTHD-1:0]   inport_sample[2:0];

   always_comb begin
      irq = 1'b0;
      waitrequest = write ? 1'b0 : (read ? ~read_latency : 1'b0);
   end
   always_ff @ (posedge clock) begin
      inport_sample[0] <= inport;
      inport_sample[1] <= inport_sample[0];
      inport_sample[2] <= inport_sample[1];
   end
   always_ff @ (posedge clock) begin
      if (clock_sreset) begin
         read_latency <= 1'b0;
         readdata <= {WIDTHD{1'bx}};
      end
      else begin
         read_latency <= read_latency ? 1'b0 : read;
         readdata <= inport_sample[2];
      end
   end

endmodule
