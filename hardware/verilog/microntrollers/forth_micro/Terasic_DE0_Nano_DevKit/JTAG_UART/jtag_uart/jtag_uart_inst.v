	jtag_uart u0 (
		.clock_clk         (<connected-to-clock_clk>),         // clock.clk
		.irq_irq           (<connected-to-irq_irq>),           //   irq.irq
		.reset_reset_n     (<connected-to-reset_reset_n>),     // reset.reset_n
		.slave_chipselect  (<connected-to-slave_chipselect>),  // slave.chipselect
		.slave_address     (<connected-to-slave_address>),     //      .address
		.slave_read_n      (<connected-to-slave_read_n>),      //      .read_n
		.slave_readdata    (<connected-to-slave_readdata>),    //      .readdata
		.slave_write_n     (<connected-to-slave_write_n>),     //      .write_n
		.slave_writedata   (<connected-to-slave_writedata>),   //      .writedata
		.slave_waitrequest (<connected-to-slave_waitrequest>)  //      .waitrequest
	);

