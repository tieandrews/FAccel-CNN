module micro_uart # (
            parameter            CLOCK_RATE_HZ = 50000000,
            parameter            BAUD_RATE = 57600,
            parameter            WIDTHD = 18
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
   output   logic                irq,
   
   input    logic                rxd,
   output   logic                txd,
   output   logic                txd_oe
);
            localparam           ONE = 128'h1;
            localparam           ZERO = 128'h0;
            localparam           DONTCARE = {128{1'bx}};
   enum     logic [3:0]          {S1, S2, S3, S4} fsm;
            logic [2:0]          rxd_sample;
            logic [3:0]          control_reg;
            logic [7:0]          rx_data_out, rx_data_reg;
            logic                rx_data_valid, tx_data_in_valid, rx_busy, rx_error;
            logic                read_latency, baud_mult16_ena, tx_busy, tx_done_ena;
            logic                data_ready, data_ready_sreset;
            
            logic                rx_irq, rx_irq_sreset;
   micro_uart_rx                 # (
                                    .CLOCK_RATE_HZ(CLOCK_RATE_HZ),
                                    .BAUD_RATE(BAUD_RATE),
                                    .WIDTHD(WIDTHD)
                                 )
                                 rx (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .baud_mult16_ena(baud_mult16_ena),
                                    .enable_rxd(control_reg[0]),
                                    .irq(rx_irq),
                                    .irq_sreset(rx_irq_sreset),
                                    .data_ready(data_ready),
                                    .data_ready_sreset(data_ready_sreset),
                                    .busy(rx_busy),
                                    .error(rx_error),
                                    .data_out(rx_data_out),
                                    .data_valid(rx_data_valid),
                                    .rxd(rxd)
                                 );

            logic                tx_irq;
   micro_uart_tx                 # (
                                    .CLOCK_RATE_HZ(CLOCK_RATE_HZ),
                                    .BAUD_RATE(BAUD_RATE),
                                    .WIDTHD(WIDTHD)
                                 )
                                 tx (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .baud_mult16_ena(baud_mult16_ena),
                                    .enable_txd(control_reg[1]),
                                    .data_in(writedata[7:0]),
                                    .data_in_valid(tx_data_in_valid),
                                    .busy(tx_busy),
                                    .done_ena(tx_done_ena),
                                    .irq(tx_irq),
                                    .txd(txd),
                                    .txd_oe(txd_oe)
                                 );
   
   always_comb begin
      waitrequest = write ? 1'b0 : (read ? ~read_latency : 1'b0);
      irq = (control_reg[2] & rx_irq) | (control_reg[3] & tx_irq);
      tx_data_in_valid = 1'b0;
      rx_irq_sreset = 1'b0;
      data_ready_sreset = 1'b0;
      case (address)
         4'h1 : begin
            data_ready_sreset = read;
         end
         4'h2 : begin
            tx_data_in_valid = write;
         end
         default : begin
            rx_irq_sreset = write & writedata[0];
         end
      endcase
   end
   always_ff @ (posedge clock) begin
      if (clock_sreset) begin
      end
      else begin
         read_latency <= read_latency ? 1'b0 : read;
         if (rx_data_valid) begin
            rx_data_reg <= rx_data_out;
         end
         case (address)
            4'h0 : begin
               readdata <= {data_ready, tx_busy, control_reg};
               if (write)
                  control_reg <= writedata[3:0];
            end
            4'h1 : begin
               readdata <= rx_data_reg;
            end
         endcase
      end
   end
   
endmodule
