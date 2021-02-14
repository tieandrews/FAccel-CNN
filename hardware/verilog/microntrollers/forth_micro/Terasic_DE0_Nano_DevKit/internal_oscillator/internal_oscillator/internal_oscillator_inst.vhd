	component internal_oscillator is
		port (
			clkout : out std_logic;        -- clk
			oscena : in  std_logic := 'X'  -- oscena
		);
	end component internal_oscillator;

	u0 : component internal_oscillator
		port map (
			clkout => CONNECTED_TO_clkout, -- clkout.clk
			oscena => CONNECTED_TO_oscena  -- oscena.oscena
		);

