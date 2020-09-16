`timescale 1ns/1ns
module micro_uart_tb();

   integer  i;
   logic    clock, clock_sreset;
   
   always #10 clock = ~clock;
     
   logic [3:0]       address;
   logic [17:0]      writedata, readdata;
   logic             read, write, waitrequest, irq, txd, rxd, txd_oe;
   
   micro_uart        # (
                        .WIDTHD(18),
                        .BAUD_RATE(115200),
                        .CLOCK_RATE_HZ(50000000)
                     )
                     dut (
                        .clock(clock),
                        .clock_sreset(clock_sreset),
                        .address (address),
                        .writedata(writedata),
                        .readdata(readdata),
                        .read(read),
                        .write(write),
                        .waitrequest(waitrequest),
                        .irq(irq),
                        .txd(txd),
                        .txd_oe(txd_oe),
                        .rxd(rxd)
                     );
                     
   initial begin
      clock = 1'b0;
      clock_sreset = 1'b0;
      for (i=0; i<5; i++)
         @ (posedge clock);
      clock_sreset = 1'b1;
      @ (posedge clock);
      clock_sreset = 1'b0;
      
      @ (posedge clock);
      address = 4'h0;
      writedata = 'h3;
      write = 1'b1;
      @ (posedge clock);
      write = 1'b0;
      
      address = 4'h2;
      writedata = 'h41;
      write = 1'b1;
      @ (posedge clock);
      write = 1'b0;
   end


endmodule
