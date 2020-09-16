`timescale 1ns/1ns
module fp_mlt_tb();
   
   localparam     EXP = 8;
   localparam     MANT = 23;
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
   
   logic [WIDTH-1:0] dataa, datab, result;
   logic             data_valid, result_valid;
   
   initial begin
      dataa = 32'h0;
      datab = 32'h0;
      data_valid = 1'b0;
      clock_sreset = 1'b0;
      for (i=0; i<5; i++)
         @ (posedge clock);
      clock_sreset = 1'b1;
      @ (posedge clock);
      clock_sreset = 1'b0;
      for (i=0; i<5; i++) begin
         data_valid = 1'b1;
         case (i)
            0 : begin
               dataa = 32'h41bef920;
               datab = 32'h42157f8e;
            end
            1 : begin
               dataa = 32'h41bef920;
               datab = 32'hc1bef920;
            end
         endcase
         @ (posedge clock);
         data_valid = 1'b0;
         dataa = 32'h0;
         datab = 32'h0;
         @ (posedge clock);
      end
   end
   
   fp_mlt      # (
                  .EXP(EXP),
                  .MANT(MANT),
                  .WIDTH(WIDTH),
                  .LCYCLES(2)
               )
               dut (
                  .clock(clock),
                  .clock_sreset(clock_sreset),
                  .data_valid(data_valid),
                  .dataa(dataa),
                  .datab(datab),
                  .result_valid(result_valid),
                  .result(result)
               );
   
endmodule
