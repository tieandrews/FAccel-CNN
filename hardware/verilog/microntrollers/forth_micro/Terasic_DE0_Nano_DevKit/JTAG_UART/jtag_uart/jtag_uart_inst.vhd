	component jtag_uart is
		port (
			clock_clk         : in  std_logic                     := 'X';             -- clk
			irq_irq           : out std_logic;                                        -- irq
			reset_reset_n     : in  std_logic                     := 'X';             -- reset_n
			slave_chipselect  : in  std_logic                     := 'X';             -- chipselect
			slave_address     : in  std_logic                     := 'X';             -- address
			slave_read_n      : in  std_logic                     := 'X';             -- read_n
			slave_readdata    : out std_logic_vector(31 downto 0);                    -- readdata
			slave_write_n     : in  std_logic                     := 'X';             -- write_n
			slave_writedata   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			slave_waitrequest : out std_logic                                         -- waitrequest
		);
	end component jtag_uart;

	u0 : component jtag_uart
		port map (
			clock_clk         => CONNECTED_TO_clock_clk,         -- clock.clk
			irq_irq           => CONNECTED_TO_irq_irq,           --   irq.irq
			reset_reset_n     => CONNECTED_TO_reset_reset_n,     -- reset.reset_n
			slave_chipselect  => CONNECTED_TO_slave_chipselect,  -- slave.chipselect
			slave_address     => CONNECTED_TO_slave_address,     --      .address
			slave_read_n      => CONNECTED_TO_slave_read_n,      --      .read_n
			slave_readdata    => CONNECTED_TO_slave_readdata,    --      .readdata
			slave_write_n     => CONNECTED_TO_slave_write_n,     --      .write_n
			slave_writedata   => CONNECTED_TO_slave_writedata,   --      .writedata
			slave_waitrequest => CONNECTED_TO_slave_waitrequest  --      .waitrequest
		);

