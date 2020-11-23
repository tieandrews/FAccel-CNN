module de0_nano (
    input   logic               clock50,
    
    output  logic [7:0]         led,
    
    output  logic               sdram_clock,
    output  logic [12:0]        sdram_addr,
    output  logic [1:0]         sdram_ba,
    output  logic               sdram_cas_n,
    output  logic               sdram_cke,
    output  logic               sdram_cs_n,
    inout   logic [15:0]        sdram_dq,
    output  logic [1:0]         sdram_dqm,
    output  logic               sdram_ras_n,
    output  logic               sdram_we_n
);
            logic               internal_osc;
            logic               pll0_areset, pll0_locked;
            logic               system_clock, system_clock_sreset;
        
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
                                    
                                    .led_export(led),
                                    
                                    .sdram_addr(sdram_addr),
                                    .sdram_ba(sdram_ba),
                                    .sdram_cas_n(sdram_cas_n),
                                    .sdram_cke(sdram_cke),
                                    .sdram_cs_n(sdram_cs_n),
                                    .sdram_dq(sdram_dq),
                                    .sdram_dqm(sdram_dqm),
                                    .sdram_ras_n(sdram_ras_n),
                                    .sdram_we_n(sdram_we_n)
                                    
                                );

endmodule
