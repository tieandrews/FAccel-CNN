module de0_nano (
    input   logic               clock50,
    output  logic   [7:0]       led
);
            logic               internal_osc;
            logic               pll0_areset, pll0_locked;
            logic               system_clock, system_clock_sreset, sdram_clock;
        
    oscillator                  (
                                    .oscena(1'b1),
                                    .clkout(internal_osc)
                                );

    PLL0                        pll0 (
                                    .areset(pll0_areset),
                                    .inclk0(clock50),
                                    .locked(pll0_locked),
                                    .c0(system_clock),
                                    .c1(sdram_clock)
                                );
    
    system_monitor              # (
                                    .CLOCKS(1)
                                )
                                monitor0 (
                                    .clock(internal_osc),
                                    .pll_clocks({system_clock}),
                                    .pll_locked(pll0_locked),
                                    .pll_areset(pll0_areset),
                                    .pll_sreset({system_clock_sreset})
                                );

    qsys_block                  qsys (
                                    .clock_clk(system_clock),
                                    .clock_sreset_reset_n(~system_clock_sreset),
                                    .led_export(led)
                                );

endmodule
