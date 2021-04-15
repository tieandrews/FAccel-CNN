module tpg_test # (
            parameter           TEST = "VGA" // or "XGA"
)
(
    input   logic               clock50,
    output  logic [3:0]         vga_red,
    output  logic [3:0]         vga_green,
    output  logic [3:0]         vga_blue,
    output  logic               vga_vsync,
    output  logic               vga_hsync
);
            localparam          XRES = (TEST == "VGA") ? 640 : 1024;
            localparam          YRES = (TEST == "VGA") ? 480 : 768;
            localparam          HS = (TEST == "VGA") ? 96 : 136;
            localparam          HFP = (TEST == "VGA") ? 16 : 24;
            localparam          HBP = (TEST == "VGA") ? 48 : 160;
            localparam          VS = (TEST == "VGA") ? 2 : 6;
            localparam          VFP = (TEST == "VGA") ? 10 : 3;
            localparam          VBP = (TEST == "VGA") ? 33 : 29;
            localparam          FIFO_DEPTH = (TEST == "VGA") ? 512 : 1024;
            logic               st_ready, st_valid, st_sop, st_eop;
            logic [15:0]        st_data;
            logic [15:0]        vga_rgb;
            logic               pll0_areset, pll0_locked;
            logic               system_clock, system_clock_sreset;
            logic               vga_clock, vga_clock_sreset;
            logic               vga_clock25, vga_clock65;
            
    assign {vga_red, vga_green, vga_blue} = {vga_rgb[15:12], vga_rgb[10:7], vga_rgb[4:1]};
    
    pll0                        pll0 (
                                    .areset(pll0_areset),
                                    .inclk0(clock50),
                                    .c0(system_clock),
                                    .c1(vga_clock25),
                                    .c2(vga_clock65),
                                    .locked(pll0_locked)
                                );
                                
    generate
        if (TEST == "VGA") begin
            assign vga_clock = vga_clock25;
        end
        else begin
            assign vga_clock = vga_clock65;
        end
    endgenerate
                                
    system_monitor              # (
                                    .CLOCKS(2)
                                )
                                monitor (
                                    .clock(clock50),
                                    .pll_clocks({vga_clock, system_clock}),
                                    .pll_locked(pll0_locked),
                                    .pll_areset(pll0_areset),
                                    .pll_sreset({vga_clock_sreset, system_clock_sreset})
                                );
                                
    //////////////////////////////////////////////////////////////////////////
    
    	tpg_test_pd_block       pd_block (
                                    .clk_clk(system_clock),
                                    .reset_reset_n(~system_clock_sreset),
                                    .vga_rgb(vga_rgb),
                                    .vga_valid(),
                                    .vga_vsync(vga_vsync),
                                    .vga_hsync(vga_hsync),
                                    .vga_clock_clk(vga_clock),
                                    .vga_clock_sreset_reset_n(~vga_clock_sreset)
                                );


endmodule
