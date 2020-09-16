module micro_embedded # (
            parameter               CLOCK_RATE_HZ = 50000000,
            parameter               FILE = "code.mif",    // these parameters must be driven with values
            parameter               WIDTH = 32,
            parameter               OP_MASK = 32'hffffffff,
            parameter               ISA = 6,
            parameter               RAM_WORDS = 512,
            parameter               STACK_DEPTH = 16,
            parameter               MULT_SIZE = WIDTH
)
(
   input    logic                   clock,
   input    logic                   clock_sreset,
   output   logic                   led
);
   ///////////////////////////////////////////////////////////////////////////
            localparam              RESET_ADDR = (ISA == 6) ? 'h24 : 'h14;
            localparam              IRQ_ADDR = (ISA == 6) ? 'h20 : 'h10;

   ///////////////////////////////////////////////////////////////////////////
            localparam              RAM0_BASE = 0;
            localparam              RAM0_WIDTHD = WIDTH;
            localparam              RAM0_WORDS = RAM_WORDS;
            localparam              RAM0_WIDTHA = $clog2(RAM0_WORDS);
            localparam              RAM0_END = (RAM0_BASE + RAM0_WORDS) - 1;
            localparam              RAM0_FILE = FILE;
            
   ///////////////////////////////////////////////////////////////////////////
            localparam              JTAG_BASE = RAM0_END + 1;
            localparam              JTAG_WIDTHD = WIDTH;
            localparam              JTAG_WORDS = 16;
            localparam              JTAG_WIDTHA = $clog2(JTAG_WORDS);
            localparam              JTAG_END = (JTAG_BASE + JTAG_WORDS) - 1;
            
   ///////////////////////////////////////////////////////////////////////////
            localparam              PORT0_BASE = JTAG_END + 1;
            localparam              PORT0_WIDTHD = 1;
            localparam              PORT0_WORDS = 16;
            localparam              PORT0_WIDTHA = $clog2(PORT0_WORDS);
            localparam              PORT0_END = (PORT0_BASE + PORT0_WORDS) - 1;
            
   ///////////////////////////////////////////////////////////////////////////
            localparam              TIMER0_BASE = PORT0_END + 1;
            localparam              TIMER0_WIDTHD = WIDTH;
            localparam              TIMER0_WORDS = 16;
            localparam              TIMER0_WIDTHA = $clog2(TIMER0_WORDS);
            localparam              TIMER0_END = (TIMER0_BASE + TIMER0_WORDS) - 1;
            
   ///////////////////////////////////////////////////////////////////////////
            localparam              WIDTHA = $clog2(TIMER0_END);
            
   ///////////////////////////////////////////////////////////////////////////
   initial begin
      $display("RESET_ADDRESS %x", RESET_ADDR);
      $display("IRQ_ADDRESS   %x", IRQ_ADDR);
      $display("RAM0_BASE     %x", RAM0_BASE);
      $display("JTAG_BASE     %x", JTAG_BASE);
      $display("PORT0_BASE    %x", PORT0_BASE);
      $display("TIMER0_BASE   %x", TIMER0_BASE);
   end
            
   ///////////////////////////////////////////////////////////////////////////
            logic [WIDTHA-1:0]      core_address;
            logic [WIDTH-1:0]       core_writedata, core_readdata, core_irq;
            logic                   core_read, core_write, core_waitrequest;            
            
   ///////////////////////////////////////////////////////////////////////////
            wire                    chipselect_ram0 = (core_address >= RAM0_BASE) && (core_address <= RAM0_END);
            wire                    chipselect_jtag = (core_address >= JTAG_BASE) && (core_address <= JTAG_END);
            wire                    chipselect_port0 = (core_address >= PORT0_BASE) && (core_address <= PORT0_END);
            wire                    chipselect_timer0 = (core_address >= TIMER0_BASE) && (core_address <= TIMER0_END);
            
   ///////////////////////////////////////////////////////////////////////////
   micro                         # (
                                    .WIDTHA(WIDTHA),
                                    .WIDTHD(WIDTH),
                                    .ISA(ISA),
                                    .RESET_ADDR(RESET_ADDR),
                                    .STACK_ADDR(RAM0_BASE + RAM0_WORDS - STACK_DEPTH), 
                                    .IRQ_ADDR(IRQ_ADDR),
                                    .OP_MASK(OP_MASK),
                                    .MULT_SIZE(MULT_SIZE)
                                 )
                                 core (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .address(core_address),
                                    .writedata(core_writedata),
                                    .readdata(core_readdata),
                                    .read(core_read),
                                    .write(core_write),
                                    .waitrequest(core_waitrequest),
                                    .irq(core_irq)
                                 );
                                 
   ///////////////////////////////////////////////////////////////////////////
   logic [RAM0_WIDTHD-1:0]       ram0_readdata;
   logic                         ram0_waitrequest;
   micro_ram                     # (
                                    .WIDTHD(RAM0_WIDTHD),
                                    .WIDTHA(RAM0_WIDTHA),
                                    .RAM_TYPE("MIF"),
                                    .FILE(RAM0_FILE)
                                 )
                                 ram0 (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .address(core_address[RAM0_WIDTHA-1:0]),
                                    .writedata(core_writedata[RAM0_WIDTHD-1:0]),
                                    .readdata(ram0_readdata[RAM0_WIDTHD-1:0]),
                                    .read(chipselect_ram0 & core_read),
                                    .write(chipselect_ram0 & core_write),
                                    .waitrequest(ram0_waitrequest)
                                 );
                                 
   ///////////////////////////////////////////////////////////////////////////
   logic [JTAG_WIDTHD-1:0]       jtag_readdata;
   logic                         jtag_waitrequest, jtag_irq;
   jtag_uart_top                 # (
                                    .WIDTHD(JTAG_WIDTHD)
                                 )
                                 jtag (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .address(core_address[JTAG_WIDTHA-1:0]),
                                    .writedata(core_writedata[JTAG_WIDTHD-1:0]),
                                    .readdata(jtag_readdata[JTAG_WIDTHD-1:0]),
                                    .read(chipselect_jtag & core_read),
                                    .write(chipselect_jtag & core_write),
                                    .waitrequest(jtag_waitrequest),
                                    .irq(jtag_irq)
                                 );
                                 
   ///////////////////////////////////////////////////////////////////////////
   logic [PORT0_WIDTHD-1:0]      port0_readdata;
   logic                         port0_waitrequest;
   micro_outport                 # (
                                    .WIDTHD(PORT0_WIDTHD),
                                    .RESET_STATE(0)
                                 )
                                 port0 (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .address(core_address[PORT0_WIDTHA-1:0]),
                                    .writedata(core_writedata[PORT0_WIDTHD-1:0]),
                                    .readdata(port0_readdata[PORT0_WIDTHD-1:0]),
                                    .read(chipselect_port0 & core_read),
                                    .write(chipselect_port0 & core_write),
                                    .waitrequest(port0_waitrequest),
                                    .outport(led)
                                 );
                                 
   ///////////////////////////////////////////////////////////////////////////
   logic [TIMER0_WIDTHD-1:0]     timer0_readdata;
   logic                         timer0_waitrequest, timer0_irq;
   micro_simple_timer            # (
                                    .WIDTHD(TIMER0_WIDTHD)
                                 )
                                 timer0 (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .address(core_address[TIMER0_WIDTHA-1:0]),
                                    .writedata(core_writedata[TIMER0_WIDTHD-1:0]),
                                    .readdata(timer0_readdata[TIMER0_WIDTHD-1:0]),
                                    .read(chipselect_timer0 & core_read),
                                    .write(chipselect_timer0 & core_write),
                                    .waitrequest(timer0_waitrequest),
                                    .irq(timer0_irq)
                                 );
                                 
   ///////////////////////////////////////////////////////////////////////////
   always_comb begin
      core_irq = {timer0_irq};
      core_readdata = ram0_readdata;
      core_waitrequest = ram0_waitrequest;
      if (chipselect_jtag)
         {core_readdata, core_waitrequest} = {jtag_readdata, jtag_waitrequest};
      if (chipselect_port0)
         {core_readdata, core_waitrequest} = {port0_readdata, port0_waitrequest};
      if (chipselect_timer0)
         {core_readdata, core_waitrequest} = {timer0_readdata, timer0_waitrequest};
   end

endmodule
