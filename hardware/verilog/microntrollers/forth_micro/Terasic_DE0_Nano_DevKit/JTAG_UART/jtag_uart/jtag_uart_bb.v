
module jtag_uart (
	clock_clk,
	irq_irq,
	reset_reset_n,
	slave_chipselect,
	slave_address,
	slave_read_n,
	slave_readdata,
	slave_write_n,
	slave_writedata,
	slave_waitrequest);	

	input		clock_clk;
	output		irq_irq;
	input		reset_reset_n;
	input		slave_chipselect;
	input		slave_address;
	input		slave_read_n;
	output	[31:0]	slave_readdata;
	input		slave_write_n;
	input	[31:0]	slave_writedata;
	output		slave_waitrequest;
endmodule
