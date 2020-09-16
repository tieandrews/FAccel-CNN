module micro_uart_tx # (
            parameter            CLOCK_RATE_HZ = 50000000,
            parameter            BAUD_RATE = 115200,
            parameter            WIDTHD = 18
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   input    logic                baud_mult16_ena,
   input    logic                enable_txd,
   input    logic [7:0]          data_in,
   input    logic                data_in_valid,
   output   logic                busy,
   output   logic                done_ena,
   output   logic                irq,
   
   output   logic                txd,
   output   logic                txd_oe
);
            integer              i;
            localparam           ZERO = 128'h0;
            localparam           ONE = 128'h1;
            localparam           DONT_CARE = {128{1'bx}};
            localparam           BAUD_CLOCKS = (CLOCK_RATE_HZ / BAUD_RATE);
            localparam           WIDTHB = $clog2(BAUD_CLOCKS - 1);
   enum     logic [3:0]          {S1, S2, S3, S4} fsm;
            logic [3:0]          bit_counter;
            logic [WIDTHB-1:0]   bit_width;
            logic [7:0]          rev_data;
            logic [9:0]          data_reg;
            
   initial begin
      $display("Baud Clocks = %d", BAUD_CLOCKS);
   end

   always_comb begin
      for (i=0; i<8; i++) begin
         rev_data[i] = data_in[i];//7-i];
      end
   end
   always_ff @ (posedge clock) begin
      if (clock_sreset) begin
         txd <= 1'b1;
         txd_oe <= 1'b0;
         irq <= 1'b0;
         bit_width <= DONT_CARE[WIDTHB-1:0];
         bit_counter <= 4'bx;
         data_reg <= 10'bx;
         busy <= 1'b0;
         fsm <= S1;
      end
      else begin
         case (fsm)
            S1 : begin
               bit_width <= ZERO[WIDTHB-1:0];
               bit_counter <= 4'h9;
               data_reg <= {1'b1, data_in, 1'b0};
               if (enable_txd & data_in_valid) begin
                  txd <= 1'b0;
                  txd_oe <= 1'b1;
                  busy <= 1'b1;
                  fsm <= S2;
               end
            end
            S2 : begin
               txd <= data_reg[0];
               if (bit_width >= (BAUD_CLOCKS - 1)) begin
                  data_reg <= {1'bx, data_reg[9:1]};
                  bit_width <= ZERO[WIDTHB-1:0];
                  bit_counter <= bit_counter - 4'h1;
                  if (~|bit_counter) begin
                     fsm <= S1;
                     busy <= 1'b0;
                     txd_oe <= 1'b0;
                  end
               end
               else begin
                  bit_width <= bit_width + ONE[WIDTHB-1:0];
               end
            end
         endcase
      end
   end

endmodule
