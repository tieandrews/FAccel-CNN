// floating point for neural networks
// no denorm no NAN or inf or rouding

// define the type of stage logic
`ifndef __ADD_TYPES
   `define __ADD_TYPES
   `define COMBINATORIAL always_comb
   `define REGISTERED always_ff @ (posedge clock)

   // set the stages - has to match LCYCLES
   `define ADD_STAGE1 `COMBINATORIAL
   `define ADD_STAGE2 `REGISTERED
   `define ADD_STAGE3 `COMBINATORIAL
   `define ADD_STAGE4 `REGISTERED
   `define ADD_STAGE5 `REGISTERED
   `define ADD_STAGE6 `REGISTERED
`endif

module fp_add # (
            parameter            EXP = 8,
            parameter            MANT = 7,
            parameter            WIDTH = 1 + EXP + MANT,
            parameter            LCYCLES = 4
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   input    logic                data_valid,
   input    logic [WIDTH-1:0]    dataa,
   input    logic [WIDTH-1:0]    datab,
   output   logic                result_valid,
   output   logic [WIDTH-1:0]    result
);
            localparam           DONTCARE = {WIDTH*2{1'bx}};
            localparam           ZERO = {WIDTH*2{1'b0}};
            localparam           ONE = {ZERO, 1'b1};
            localparam           BIAS = (2 ** (EXP - 1)) - 1;
            localparam           WIDTHB = $clog2(MANT+1) + 1;
            integer              i, j;
            logic                sa[3:0], sb[3:0], sr  /* synthesis preserve */;
            logic [EXP-1:0]      ea[3:0], eb[3:0], er  /* synthesis preserve */;
            logic [MANT:0]       ma[3:0], mb[3:0], mr  /* synthesis preserve */;
            logic [WIDTHB-1:0]   zero_bits;
            logic [EXP:0]        exp_diff, rexp;
            logic [4:0]          valid;
            wire                 anode_zero = ~|dataa[WIDTH-2:0];
            wire                 bnode_zero = ~|datab[WIDTH-2:0];
            wire                 b_gt_a_exp = {sb[0], eb[0]} > {sa[0], ea[0]};
            wire                 b_eq_a_exp = {sb[0], eb[0]} == {sa[0], ea[0]};
            wire                 b_gt_a_mant = mb[0] > ma[0];
            wire                 mr_zero = ~|mr;
            
   `ADD_STAGE1 begin // insert implied '1' if non zero
         sa[0] <= dataa[WIDTH-1];
         ea[0] <= dataa[WIDTH-2:MANT];
         ma[0] <= {~anode_zero, dataa[MANT-1:0]};
         sb[0] <= datab[WIDTH-1];
         eb[0] <= datab[WIDTH-2:MANT];
         mb[0] <= {~bnode_zero, datab[MANT-1:0]};
         valid[0] <= data_valid & ~clock_sreset;
      end
   
   `ADD_STAGE2 begin  // swap if abs(exponent b) is larger then abs(exponent a)
      if (b_gt_a_exp | (b_eq_a_exp & b_gt_a_mant)) begin
         {sa[1], ea[1], ma[1]} <= {sb[0], eb[0], mb[0]};
         {sb[1], eb[1], mb[1]} <= {sa[0], ea[0], ma[0]};
      end
      else begin
         {sa[1], ea[1], ma[1]} <= {sa[0], ea[0], ma[0]};
         {sb[1], eb[1], mb[1]} <= {sb[0], eb[0], mb[0]};
      end
      valid[1] <= valid[0] & ~clock_sreset;
   end
   
   `ADD_STAGE3 begin  // find the exponent difference
      exp_diff <= {1'b0, ea[1]} - {1'b0, eb[1]};
      {sa[2], ea[2], ma[2]} <= {sa[1], ea[1], ma[1]};
      sb[2] <= sb[1];
      eb[2] <= DONTCARE[EXP-1:0];
      mb[2] <= mb[1];
      valid[2] <= valid[1] & ~clock_sreset;
   end
   
   `ADD_STAGE4 begin  // and align to add 
      {sa[3], ea[3], ma[3]} <= {sa[2], ea[2], ma[2]};
      sb[3] <= sb[2];
      eb[3] <= DONTCARE[EXP-1:0];
      mb[3] <= mb[2] >> exp_diff;
      valid[3] <= valid[2] & ~clock_sreset;
   end
   
   `ADD_STAGE5 begin  // perform the add / subtract
      sr <= sa[3];
      er <= ea[3];
      mr <= ma[3] + (mb[3] ^ {MANT{(sa[3] ~^ sb[3])}});
      /*if (sa[3] ~^ sb[3]) begin
         mr <= ma[3] + mb[3];
      end
      else begin
         mr <=  ma[3] - mb[3];
      end*/
      valid[4] <= valid[3] & ~clock_sreset;
   end
   
   always_comb begin : bc // normalise the mantissa of add/sub result
      zero_bits = ZERO[WIDTHB-1:0];
      for (i=(MANT); i>=0; i--) begin
         if (mr[i]) begin
            zero_bits = MANT[WIDTHB-1:0] - i[WIDTHB-1:0];
            break;
         end
      end
      rexp = er - zero_bits;
   end
       
   `ADD_STAGE6 begin  // realign the result and adjust the exponent
      result_valid <= valid[4] & ~clock_sreset;
      if (mr_zero)
         result <= ZERO[WIDTH-1:0];
      else begin
         result <= {sr, rexp[EXP-1:0], mr[MANT-1:0] << zero_bits};
      end
   end
   
endmodule
