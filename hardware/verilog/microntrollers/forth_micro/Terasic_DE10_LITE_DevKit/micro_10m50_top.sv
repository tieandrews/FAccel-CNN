/*
clock	Location	PIN_P11
led	Location	PIN_A8
onewire	Location	PIN_AA8
*/
module micro_10m50_top # (
            parameter               WIDTH = 20,
            parameter               ISA = 5,
            parameter               RAM_WORDS = 2048,
            parameter               MULT_SIZE = 18,
            parameter               STACK_DEPTH = 32,
            parameter               FILE = "code.mif",
            parameter               SYSTEM_CLOCK = 50000000,
            parameter               OP_MASK = 32'hffffffff
)
(
   input    logic                   clock,
   output   logic                   led,
   inout    wire                    onewire
);
   ///////////////////////////////////////////////////////////////////////////
            logic                   pll_areset, pll_locked, osc;
            logic                   system_clock, system_clock_sreset;
   pll_10m                          pll (
                                       .areset(pll_areset),
                                       .inclk0(clock),
                                       .c0(system_clock),
                                       .locked(pll_locked)
                                    );
   
   internal_oscillator              oscillator (
                                       .oscena(1'b1),
                                       .clkout(osc)
                                    );
                                    
   system_monitor                   # (
                                       .CLOCKS(1)
                                    )
                                    monitor (
                                       .clock(osc),
                                       .pll_clocks({system_clock}),
                                       .pll_locked(pll_locked),
                                       .pll_areset(pll_areset),
                                       .pll_sreset({system_clock_sreset})
                                    );
                              
   ///////////////////////////////////////////////////////////////////////////
   micro_embedded                   # (
                                       .CLOCK_RATE_HZ(SYSTEM_CLOCK),
                                       .FILE(FILE),
                                       .WIDTH(WIDTH),
                                       .OP_MASK(OP_MASK),
                                       .ISA(ISA),
                                       .RAM_WORDS(RAM_WORDS),
                                       .STACK_DEPTH(STACK_DEPTH),
                                       .MULT_SIZE(MULT_SIZE)
                                    )
                                    micro (
                                       .clock(system_clock),
                                       .clock_sreset(system_clock_sreset),
                                       .led(led)
                                    );

endmodule
