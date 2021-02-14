module jtag_uart_top # (
            parameter            WIDTHD = 18
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   input    logic [3:0]          address,
   output   logic [WIDTHD-1:0]   readdata,
   input    logic [WIDTHD-1:0]   writedata,
   input    logic                read,
   input    logic                write,
   output   logic                waitrequest,
   output   logic                irq
);
            localparam           MSB1 = (WIDTHD == 32) ? 32 : (16 + (WIDTHD - 9));
            localparam           MSB2 = (WIDTHD == 32) ? 32 : (16 + (WIDTHD - 5));
            logic [31:0]         slave_readdata, slave_writedata;
            
   always_comb begin
      slave_writedata = 32'h0;
      readdata = {WIDTHD{1'b0}};
      if (address == 4'h0) begin
         slave_writedata[7:0] = writedata[7:0];
         readdata = {slave_readdata[MSB1-1:16], slave_readdata[15], slave_readdata[7:0]};
      end
      if (address == 4'h1) begin
         slave_writedata[10] = writedata[4];
         readdata = {slave_readdata[MSB2-1:16], slave_readdata[10:8], slave_readdata[1:0]}; // {fifo_space, ac, wi, ri, we, re};
      end
   end

   jtag_uart                     jtag_uart (
                                    .clock_clk(clock),
                                    .reset_reset_n(~clock_sreset),
                                    .slave_chipselect(1'b1),
                                    .slave_address(address[0]),
                                    .slave_read_n(~read),
                                    .slave_readdata(slave_readdata),
                                    .slave_write_n(~write),
                                    .slave_writedata(slave_writedata),
                                    .slave_waitrequest(waitrequest),
                                    .irq_irq(irq)
                                 );
endmodule
