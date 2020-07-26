`timescale 1ns/1ns
module fp_i2f_tb();
   
   localparam     EXP = 5;
   localparam     MANT = 10;
   localparam     WIDTH = 1 + EXP + MANT;
   
   localparam     BIAS = ((2 ** (EXP -1)) - 1);
   
   integer     i;
   logic       clock, clock_sreset;
   
   logic             rsa, rsb;
   logic [EXP-1:0]   rea, reb;
   logic [MANT-1:0]  rma, rmb;
   
   real              fpa;
   
   initial begin
      clock = 1'b0;
   end
   
   always #10 clock = ~clock;  
   
   logic [WIDTH-1:0] dataa, result;
   logic             data_valid, result_valid;
   
   initial begin
      dataa = 32'h0;
      data_valid = 1'b0;
      clock_sreset = 1'b0;
      for (i=0; i<5; i++)
         @ (posedge clock);
      clock_sreset = 1'b1;
      @ (posedge clock);
      clock_sreset = 1'b0;
      for (i=0; i<7; i++) begin
         data_valid = 1'b1;
         case (i)
            0 : dataa = -255;
            1 : dataa = -128;
            2 : dataa = -1;
            3 : dataa = 0;
            4 : dataa = 1;
            5 : dataa = 128;
            6 : dataa = 255;
         endcase
         @ (posedge clock);
         data_valid = 1'b0;
         dataa = 32'h0;
         @ (posedge clock);
      end
   end
   
   fp_i2f      # (
                  .EXP(EXP),
                  .MANT(MANT),
                  .WIDTH(WIDTH)
               )
               dut (
                  .clock(clock),
                  .clock_sreset(clock_sreset),
                  .data_valid(data_valid),
                  .dataa(dataa),
                  .result_valid(result_valid),
                  .result(result)
               );
   
endmodule
