module de10_lite
(
    input   logic               clock50,
    
    output  logic   [9:0]       led,
    
    output  logic   [3:0]       vga_red,
    output  logic   [3:0]       vga_green,
    output  logic   [3:0]       vga_blue,
    output  logic               vga_hsync,
    output  logic               vga_vsync,
    
    output  logic               sdram_clock,
    output  logic               sdram_cke,
    output  logic   [12:0]      sdram_addr,
    output  logic   [1:0]       sdram_ba,
    inout   logic   [15:0]      sdram_dq,
    output  logic   [1:0]       sdram_dqm,
    output  logic               sdram_ras_n,
    output  logic               sdram_cas_n,
    output  logic               sdram_cs_n,
    output  logic               sdram_we_n
);
            logic               internal_osc;
            logic               pll0_areset, pll0_locked;
            logic               system_clock, system_clock_sreset;
            logic               vga_pixel_clock, vga_pixel_clock_sreset;
            logic   [15:0]      vga_rgb;
            
    assign vga_red = vga_rgb[15:12];
    assign vga_green = vga_rgb[10:7];
    assign vga_blue = vga_rgb[4:1];
    
    
    oscillator                  oscillator (
                                    .oscena(1'b1),
                                    .clkout(internal_osc)
                                );

    PLL0                        pll0 (
                                    .areset(pll0_areset),
                                    .inclk0(clock50),
                                    .locked(pll0_locked),
                                    .c0(sdram_clock),
                                    .c1(system_clock),
                                    .c2(vga_pixel_clock)
                                );
    
    system_monitor              # (
                                    .CLOCKS(2)
                                )
                                monitor0 (
                                    .clock(internal_osc),
                                    .pll_clocks({vga_pixel_clock, system_clock}),
                                    .pll_locked(pll0_locked),
                                    .pll_areset(pll0_areset),
                                    .pll_sreset({vga_pixel_clock_sreset, system_clock_sreset})
                                );

    pd_block                    qsys (
                                    .clock_clk(system_clock),
                                    .clock_sreset_reset_n(~system_clock_sreset),
                                    .vga_clock_sreset_reset_n(~vga_pixel_clock_sreset),
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
                                    //.vga_rgb(vga_rgb),
                                    //.vga_valid(),
                                    //.vga_vsync(vga_vsync),
                                    //.vga_hsync(vga_hsync),
                                    //.vga_clock_clk(vga_pixel_clock),
                                );
                                

endmodule
