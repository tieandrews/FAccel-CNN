`timescale 1ns/1ns
module fp_f2i_tb();
   
   localparam     EXP = 5;
   localparam     MANT = 10;
   localparam     WIDTH = 1 + EXP + MANT;
   
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
   
   logic [WIDTH-1:0] dataa, i2f_result;
   logic [MANT-1:0]  f2i_result;
   logic             data_valid, i2f_result_valid, f2i_result_valid;
   
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
         dataa = 123 + (i * 7);
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
               i2f_test (
                  .clock(clock),
                  .clock_sreset(clock_sreset),
                  .data_valid(data_valid),
                  .dataa(dataa[MANT:0]),
                  .result_valid(i2f_result_valid),
                  .result(i2f_result)
               );
   
   fp_f2i      # (
                  .EXP(EXP),
                  .MANT(MANT),
                  .WIDTH(WIDTH)
               )
               dut (
                  .clock(clock),
                  .clock_sreset(clock_sreset),
                  .data_valid(i2f_result_valid),
                  .dataa(i2f_result),
                  .result_valid(f2i_result_valid),
                  .result(f2i_result)
               );
   
endmodule
