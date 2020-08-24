module fp_div # (
            parameter            EXP = 8,
            parameter            MANT = 23,
            parameter            WIDTH = (1 + EXP + MANT)
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   input    logic [WIDTH-1:0]    dataa,
   input    logic [WIDTH-1:0]    datab,
   input    logic                data_valid,
   output   logic                result_valid,
   output   logic [WIDTH-1:0]    result
);
            localparam           ZERO = {WIDTH*2{1'b0}};
            localparam           ONE = {ZERO, 1'b1};
            localparam           WIDTHC = $clog2((MANT*2)+1);
            localparam           OFFSET = (2 ** (EXP - 1)) - 1;
   enum     logic [4:0]          {S1, S2, S3, S4, S5} fsm;
            logic [MANT:0]       a_m, b_m, r_m;
            logic [EXP-1:0]      a_e, b_e, r_e;
            logic                a_s, b_s, r_s;
            logic [MANT*2:0]     quotient, divisor, dividend, remainder;
            logic [WIDTHC-1:0]   count;
   
   always_ff @ (posedge clock) begin
      if (clock_sreset) begin
         fsm <= S1;
      end
      else begin
         case (fsm)
            S1 : begin
               {a_s, a_e, a_m} <= {dataa[WIDTH-1], (dataa[WIDTH-2:MANT] - OFFSET[EXP-1:0]), 1'b1, dataa[MANT-1:0]};
               {b_s, b_e, b_m} <= {datab[WIDTH-1], (datab[WIDTH-2:MANT] - OFFSET[EXP-1:0]), 1'b1, datab[MANT-1:0]};
               result_valid <= 1'b0;
               if (data_valid)
                  fsm <= S2;
            end
            S2 : begin
               r_s <= a_s ^ b_s;
               r_e <= a_e - b_e;
               quotient <= ZERO[MANT*2:0];
               remainder <= ZERO[MANT*2:0];
               count <= ZERO[WIDTHC-1:0];
               dividend <= a_m << MANT;
               divisor <= b_m;
               fsm <= S3;
            end
            S3 : begin
               quotient <= quotient << 1;
               remainder <= remainder << 1;
               remainder[0] <= dividend[MANT*2];
               dividend <= dividend << 1;
               fsm <= S4;
            end
            S4 : begin
               r_m <= quotient[MANT+1:1];
               count <= count + ONE[WIDTHC-1:0];
               if (remainder >= divisor) begin
                  quotient[0] <= 1'b1;
                  remainder <= remainder - divisor;
               end
               if (count >= (MANT*2))
                  fsm <= S5;
               else
                  fsm <= S3;
            end
            S5 : begin
               if (~r_m[MANT]) begin
                  r_e <= r_e - ONE[EXP-1:0];
                  r_m <= r_m << 1;
               end
               else begin
                  result_valid <= 1'b1;
                  result <= {r_s, r_e + OFFSET[EXP-1:0], r_m[MANT-1:0]};
                  fsm <= S1;
               end
            end
         endcase
      end
   end
   
endmodule
