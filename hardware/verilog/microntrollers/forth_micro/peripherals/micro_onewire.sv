module micro_onewire # (
            parameter            CLOCK_RATE_HZ = 50000000,
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
   
   inout    logic                onewire
);
            localparam           ONE = 128'h1;
            localparam           ZERO = 128'h0;
            localparam           DONTCARE = {128{1'bx}};
            localparam           USEC = (CLOCK_RATE_HZ / 1000000) + 1;
            localparam           WIDTHC = $clog2(USEC);
            localparam           WIDTHB = $clog2(480);
   enum     logic [4:0]          {S1, S2, S3, S4, S5} fsm;
            logic [3:0]          control_reg;
            logic [WIDTHC-1:0]   cycle_counter;
            logic [WIDTHB-1:0]   bit_width;
            logic [2:0]          onewire_meta;
            logic [1:0]          command_reg;
            logic                read_latency, onewire_data, busy_reg, reset_ack_reg, data_reg;
            
   initial begin
      $display("CLOCK_RATE %d", CLOCK_RATE_HZ);
   end
   
   always_ff @ (posedge clock) begin
      onewire_meta <= {onewire_meta[1:0], onewire};
      onewire_data <= onewire_meta[2];
   end
   
   always_comb begin
      waitrequest = write ? 1'b0 : (read ? ~read_latency : 1'b0);
   end   
   always_ff @ (posedge clock) begin
      if (clock_sreset) begin
         read_latency <= 1'b0;
         readdata <= DONTCARE[WIDTHD-1:0];
         busy_reg <= 1'b0;
         reset_ack_reg <= 1'bx;
         onewire <= 1'bz;
         bit_width <= DONTCARE[WIDTHB-1:0];
         cycle_counter <= DONTCARE[WIDTHC-1:0];
         command_reg <= 2'bxx;
         irq <= 1'b0;
         fsm <= S1;
      end
      else begin
         read_latency <= read_latency ? 1'b0 : read;
         case (address)
            4'h0 : readdata <= {reset_ack_reg, busy_reg, onewire_data};
            4'h1 : readdata <= data_reg;
         endcase
         case (fsm)
            S1 : begin
               cycle_counter <= ZERO[WIDTHC-1:0];
               bit_width <= ZERO[WIDTHB-1:0];
               case(address)
                  4'h0 : begin
                     if (write) begin
                        command_reg <= writedata[1:0];
                        reset_ack_reg <= 1'b0;
                        busy_reg <= 1'b1;
                        onewire <= 1'b0;  // drive bus low!
                        fsm <= S2;
                     end
                  end
                  4'h1 : begin   // allow driving onewire pin high/low/tristate manually
                     if (write) begin
                        onewire <= writedata[1] ? 1'bz : writedata[0];
                     end
                  end
                  default : begin
                  end
               endcase
            end
            S2 : begin  // select transaction
               if (cycle_counter >= (USEC - 1)) begin
                  cycle_counter <= ZERO[WIDTHC-1:0];
                  case (command_reg)
                     2'h0 : begin   // reset onewire bus 480us
                        if (bit_width >= 479) begin
                           bit_width <= ZERO[WIDTHB-1:0];
                           onewire <= 1'bz;
                           fsm <= S3;
                        end
                        else begin
                           bit_width <= bit_width + ONE[WIDTHB-1:0];
                        end
                     end
                     2'h1 : begin   // write '0' bit 60us
                        if (bit_width >= 59) begin
                           bit_width <= ZERO[WIDTHB-1:0];
                           onewire <= 1'b1;
                           fsm <= S4;
                        end
                        else begin
                           bit_width <= bit_width + ONE[WIDTHB-1:0];
                        end
                     end
                     default : begin   // write '1' bit (2) and read bit (3) 1us
                        bit_width <= ZERO[WIDTHB-1:0];
                        if (command_reg == 2'h3) begin
                           onewire <= 1'bz;
                           fsm <= S5;
                        end
                        else begin
                           onewire <= 1'b1;
                           fsm <= S5;
                        end
                     end
                  endcase
               end
               else begin
                  cycle_counter <= cycle_counter + ONE[WIDTHC-1:0];
               end
            end
            S3 : begin  // RESET wait another 480us for ack response, sampled at 60us
               if (cycle_counter >= (USEC - 1)) begin
                  cycle_counter <= ZERO[WIDTHC-1:0];
                  if (bit_width >= 479) begin
                     bit_width <= ZERO[WIDTHB-1:0];
                     fsm <= S4;
                  end
                  else begin
                     bit_width <= bit_width + ONE[WIDTHB-1:0];
                  end
                  if (bit_width >= 59) begin
                     if (~onewire_data) begin
                        reset_ack_reg <= 1'b1;
                     end
                  end
               end
               else begin
                  cycle_counter <= cycle_counter + ONE[WIDTHC-1:0];
               end
            end
            S4: begin   // wait 3x 1us between words
               if (cycle_counter >= (USEC - 1)) begin
                  cycle_counter <= ZERO[WIDTHC-1:0];
                  if (bit_width >= 3) begin
                     onewire <= 1'bz;
                     busy_reg <= 1'b0;
                     fsm <= S1;
                  end
                  else begin
                     bit_width <= bit_width + ONE[WIDTHB-1:0];
                  end
               end
               else begin
                  cycle_counter <= cycle_counter + ONE[WIDTHC-1:0];
               end
            end
            S5 : begin  // wait 60us
               if (cycle_counter >= (USEC - 1)) begin
                  cycle_counter <= ZERO[WIDTHC-1:0];
                  if ((command_reg == 2'h3) && (bit_width == 12)) begin
                     data_reg <= onewire_data;
                  end
                  if (bit_width >= 59) begin
                     bit_width <= ZERO[WIDTHB-1:0];
                     onewire <= 1'bz;
                     fsm <= S4;
                  end
                  else begin
                     bit_width <= bit_width + ONE[WIDTHB-1:0];
                  end
               end
               else begin
                  cycle_counter <= cycle_counter + ONE[WIDTHC-1:0];
               end
            end
         endcase
      end
   end
   
endmodule
