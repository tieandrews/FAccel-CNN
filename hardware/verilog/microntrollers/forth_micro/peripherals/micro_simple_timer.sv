module micro_simple_timer # (
            parameter            WIDTHD = 32
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   input    logic [3:0]          address,
   input    logic [WIDTHD-1:0]   writedata,
   output   logic [WIDTHD-1:0]   readdata,
   input    logic                read,
   input    logic                write,
   output   logic                waitrequest,
   output   logic                irq
);
            localparam           ZERO = {WIDTHD{1'b0}};
            localparam           ONE = {ZERO, 1'b1};
            localparam           WIDTHT = (WIDTHD >= 32) ? 32 : WIDTHD;
            logic [WIDTHT-1:0]   timer_counter_reg, timer_reload_reg;
            logic [2:0]          control_reg;
            logic                read_latency;
   
   always_comb begin
      waitrequest = write ? 1'b0 : (read ? ~read_latency : 1'b0);
   end
   always_ff @ (posedge clock) begin
      if (clock_sreset) begin
         timer_counter_reg <= ZERO[WIDTHT-1:0];
         control_reg <= 3'b00;
         read_latency <= 1'b0;
         irq <= 1'b0;
         readdata <= {WIDTHD{1'bx}};
         timer_reload_reg <= ZERO[WIDTHT-1:0];
      end
      else begin
         if (control_reg[0]) begin  // enable timer
            if (~|timer_counter_reg) begin 
               irq <= control_reg[1];  // enable IRQ
               if (control_reg[2])  // enable reload
                  timer_counter_reg <= timer_reload_reg;
            end
            else
               timer_counter_reg <= timer_counter_reg - ONE[WIDTHD-1:0];
         end
         else begin
            timer_counter_reg <= timer_reload_reg;
         end
         read_latency <= read_latency ? 1'b0 : read;
         if (address == 4'h0) begin
            readdata <= control_reg;
            if (write)
               control_reg <= writedata[2:0];
         end
         if (address == 4'h1) begin
            readdata <= timer_counter_reg;
            if (write)
               timer_counter_reg <= writedata;
         end
         if (address == 4'h2) begin
            readdata <= timer_reload_reg;
            if (write)
               timer_reload_reg <= writedata;
         end
         if (address == 4'h3) begin
            if (write & writedata[0])
               irq <= 1'b0;
         end
      end
   end
   
endmodule
