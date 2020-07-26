
module pd_block (
	clock_clk,
	clock_sreset_reset_n,
	led_export,
	sdram_addr,
	sdram_ba,
	sdram_cas_n,
	sdram_cke,
	sdram_cs_n,
	sdram_dq,
	sdram_dqm,
	sdram_ras_n,
	sdram_we_n,
	vga_clock_clk,
	vga_clock_sreset_reset_n);	

	input		clock_clk;
	input		clock_sreset_reset_n;
	output	[9:0]	led_export;
	output	[12:0]	sdram_addr;
	output	[1:0]	sdram_ba;
	output		sdram_cas_n;
	output		sdram_cke;
	output		sdram_cs_n;
	inout	[15:0]	sdram_dq;
	output	[1:0]	sdram_dqm;
	output		sdram_ras_n;
	output		sdram_we_n;
	input		vga_clock_clk;
	input		vga_clock_sreset_reset_n;
endmodule
