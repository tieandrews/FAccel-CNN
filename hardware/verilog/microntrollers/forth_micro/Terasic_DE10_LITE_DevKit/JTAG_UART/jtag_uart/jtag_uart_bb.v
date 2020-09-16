
module jtag_uart (
	slave_chipselect,
	slave_address,
	slave_read_n,
	slave_readdata,
	slave_write_n,
	slave_writedata,
	slave_waitrequest,
	clock_clk,
	reset_reset_n,
	irq_irq);	

	input		slave_chipselect;
	input		slave_address;
	input		slave_read_n;
	output	[31:0]	slave_readdata;
	input		slave_write_n;
	input	[31:0]	slave_writedata;
	output		slave_waitrequest;
	input		clock_clk;
	input		reset_reset_n;
	output		irq_irq;
endmodule
