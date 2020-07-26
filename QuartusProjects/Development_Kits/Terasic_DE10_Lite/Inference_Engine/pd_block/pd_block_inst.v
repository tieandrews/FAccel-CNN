	pd_block u0 (
		.clock_clk                (<connected-to-clock_clk>),                //            clock.clk
		.clock_sreset_reset_n     (<connected-to-clock_sreset_reset_n>),     //     clock_sreset.reset_n
		.led_export               (<connected-to-led_export>),               //              led.export
		.sdram_addr               (<connected-to-sdram_addr>),               //            sdram.addr
		.sdram_ba                 (<connected-to-sdram_ba>),                 //                 .ba
		.sdram_cas_n              (<connected-to-sdram_cas_n>),              //                 .cas_n
		.sdram_cke                (<connected-to-sdram_cke>),                //                 .cke
		.sdram_cs_n               (<connected-to-sdram_cs_n>),               //                 .cs_n
		.sdram_dq                 (<connected-to-sdram_dq>),                 //                 .dq
		.sdram_dqm                (<connected-to-sdram_dqm>),                //                 .dqm
		.sdram_ras_n              (<connected-to-sdram_ras_n>),              //                 .ras_n
		.sdram_we_n               (<connected-to-sdram_we_n>),               //                 .we_n
		.vga_clock_clk            (<connected-to-vga_clock_clk>),            //        vga_clock.clk
		.vga_clock_sreset_reset_n (<connected-to-vga_clock_sreset_reset_n>)  // vga_clock_sreset.reset_n
	);

