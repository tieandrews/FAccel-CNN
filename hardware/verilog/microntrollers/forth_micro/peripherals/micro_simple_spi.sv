module micro_simple_spi (
   input    logic                clock,
   input    logic                clock_sreset,
   input    logic [3:0]          address,
   input    logic [WIDTHD-1:0]   writedata,
   output   logic [WIDTHD-1:0]   readdata,
   input    logic                read,
   input    logic                write,
   output   logic                waitrequest,
   output   logic                irq,
   
   output   logic                csn,
   output   logic                ce,
   output   logic                sck,
   output   logic                mosi,
   input    logic                miso
);
            localparam           ONE = 128'h1;
            localparam           ZERO = 128'h0;
            localparam           DONTCARE = {128{1'bx}};
   enum     logic [3:0]          {S1, S2, S3, S4} fsm;
            logic                read_latency;
            logic [WIDTHD_1:0]   spi_reg;
            
   always_comb begin
      case (address)
         4'h0 : readdata = spi_reg;
      endcase
   end
   
   always_ff @ (posedge clock) begin
      if (clock_sreset) begin
         csn <= 1'b1;
         ce <=
         fsm <= S1;
      end
      else begin
         case (fsm)
            S1 : begin
               case (address)
                  4'h0 : begin
                     if (write) begin
                        
                     end
                  end
               endcase
            end
         endcase
      end
   end
endmodule
