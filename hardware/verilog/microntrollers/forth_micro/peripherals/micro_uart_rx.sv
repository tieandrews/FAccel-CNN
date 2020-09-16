module micro_uart_rx # (
            parameter            CLOCK_RATE_HZ = 50000000,
            parameter            BAUD_RATE = 115200,
            parameter            WIDTHD = 18
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   output   logic                baud_mult16_ena,
   input    logic                enable_rxd,
   output   logic                irq,
   input    logic                irq_ena,
   input    logic                irq_sreset,
   output   logic                data_ready,
   input    logic                data_ready_sreset,
   output   logic                busy,
   output   logic                error,
   output   logic [7:0]          data_out,
   output   logic                data_valid,
   
   input    logic                rxd
);
            localparam           ONE = 128'h1;
            localparam           ZERO = 128'h0;
            localparam           BIT_WIDTH = (CLOCK_RATE_HZ / BAUD_RATE);
            localparam           BAUD_MULT16 = (BIT_WIDTH / 16);
            localparam           WIDTHB = $clog2(BIT_WIDTH - 1);
   enum     logic [3:0]          {S1, S2, S3, S4} fsm;
            logic [2:0]          rxd_sample;
            logic [WIDTHB-1:0]   baud_counter;
            logic [3:0]          counter, bit_count;
            logic [9:0]          data_reg;
            logic                rxd_data;

   always_ff @ (posedge clock) begin
      {rxd_data, rxd_sample} <= {rxd_sample, rxd}; 
   end
   
   always_ff @ (posedge clock) begin
      if (clock_sreset) begin
         baud_mult16_ena <= 1'b0;
         baud_counter <= ZERO[WIDTHB-1:0];
      end
      else begin
         baud_mult16_ena <= ~|baud_counter;
         if (~|baud_counter)
            baud_counter <= (BAUD_MULT16[WIDTHB-1:0] - ONE[WIDTHB-1:0]);
         else
            baud_counter <= baud_counter - ONE[WIDTHB-1:0];
      end
   end
   
   always_comb begin
      data_out = data_reg[8:1];
   end
   always_ff @ (posedge clock) begin
      if (clock_sreset) begin
         irq <= 1'b0;
         fsm <= S1;
      end
      else begin
         if (irq_sreset) begin
            irq <= 1'b0;
         end
         if (data_ready_sreset) begin
            data_ready <= 1'b0;
         end
         case (fsm)
            S1 : begin
               busy <= 1'b0;
               bit_count <= 4'h0;
               counter <= 4'h0;
               data_valid <= 1'b0;
               if (rxd_data & enable_rxd) begin
                  fsm <= S2;
               end
            end
            S2 : begin  // start
               if (~enable_rxd) begin  // are we enabled to rx?
                  fsm <= S1;
               end
               else begin
                  data_reg <= 10'h0;
                  if (~rxd_data) begin // do we have a starting low bit?
                     if (baud_mult16_ena) begin
                        if (counter[3]) begin   // are we mid way in this bit?
                           busy <= 1'b1;
                           counter <= 4'h0;
                           fsm <= S3;
                        end
                        else begin
                           counter <= counter + 4'h1;
                        end
                     end
                  end
               end
            end
            S3 : begin
               if (baud_mult16_ena) begin
                  counter <= counter + 4'h1;
                  if (&counter) begin  // span whole bit periods from mid point to mid point.
                     data_reg <= {data_reg[8:0], rxd_data};
                     bit_count <= bit_count + 4'h1;
                     if (bit_count >= 4'h8) begin  // do we have all bits including stop bit?
                        data_valid <= 1'b1;
                        irq <= irq_ena;
                        data_ready <= 1'b1;
                        fsm <= S1;
                     end
                  end
               end
            end
         endcase
      end
   end

endmodule
