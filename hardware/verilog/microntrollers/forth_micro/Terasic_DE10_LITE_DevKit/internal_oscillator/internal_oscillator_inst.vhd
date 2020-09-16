	component internal_oscillator is
		port (
			oscena : in  std_logic := 'X'; -- oscena
			clkout : out std_logic         -- clk
		);
	end component internal_oscillator;

	u0 : component internal_oscillator
		port map (
			oscena => CONNECTED_TO_oscena, -- oscena.oscena
			clkout => CONNECTED_TO_clkout  -- clkout.clk
		);

