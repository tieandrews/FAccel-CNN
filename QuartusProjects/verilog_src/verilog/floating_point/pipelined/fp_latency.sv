
module fp_latency # (
            parameter            EXP = 8,
            parameter            MANT = 9,
            parameter            LCYCLES = 2,
            parameter            WIDTH = 1 + EXP + MANT
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   input    logic                data_valid,
   input    logic [WIDTH-1:0]    dataa,
   output   logic                result_valid,
   output   logic [WIDTH-1:0]    result
);

   integer i;
   generate
      begin
         if (LCYCLES == 0) begin
            assign result = dataa;
            assign result_valid = data_valid;
         end
         if (LCYCLES > 0) begin
            logic [LCYCLES-1:0]              valid /* synthesis preserve */;
            logic [LCYCLES-1:0][WIDTH-1:0]   stage /* synthesis preserve */;
            always_ff @ (posedge clock) begin
               if (clock_sreset) begin
                  stage <= {LCYCLES*WIDTH{1'bx}};
                  valid <= {LCYCLES{1'b0}};
               end
               else begin
                  for (i=0; i<LCYCLES; i++) begin
                     if (i == 0) begin
                        stage[0] <= dataa;
                        valid[0] <= data_valid;
                     end
                     else begin
                        stage[i] <= stage[i-1];
                        valid[i] <= valid[i-1];
                     end
                  end
               end
            end
            assign result = stage[LCYCLES-1];
            assign result_valid = valid[LCYCLES-1];
         end
      end
   endgenerate

endmodule
