/*
ISA5     MSBIT 0 PFX 0x0..0xF
ISA6     MSBIT 0 PFX 0x0..0x1F

         MSBITS ISA5/6
                     EXT   EXT
ISA5      10    11    10    11
ISA6     100   101   110   111
         ---------------------
000      LDW   OVR   IOR
001      STW   ASR   XOR
010      PSH   GEQ   MLT
011      POP   ZEQ   NOP
100      SWP   ADD 
101      JNZ   ADC
110      JSR   SUB
111     (EXT)  AND
*/
module micro # (
            parameter            WIDTHA = 16,
            parameter            WIDTHD = 18,
            parameter            ISA = 5,
            parameter            OP_MASK = 32'hffffffff,
            parameter            RESET_ADDR = 'h24,
            parameter            IRQ_ADDR = 'h20,
            parameter            STACK_ADDR = 'h1e0,
            parameter            MULT_SIZE = 18
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   output   logic [WIDTHA-1:0]   address,
   output   logic [WIDTHD-1:0]   writedata,
   input    logic [WIDTHD-1:0]   readdata,
   output   logic                read,
   output   logic                write,
   input    logic                waitrequest,
   input    logic [WIDTHD-1:0]   irq
);
            localparam           REGIO = 1;     // register address/data bus
            localparam           PFX_PSH = 1'b0;
            localparam           OP = (WIDTHD / ISA);
            localparam           WIDTHI = (OP * ISA);
            localparam           WIDTHS = $clog2(OP);
            localparam           WIDTHP = (WIDTHA + WIDTHS);
            localparam           WIDTHM = MULT_SIZE * 2;
            localparam           ZERO = 128'h0;
            localparam           ONE = 128'h1;
            localparam           DONTCARE = 128'bx;
   enum     logic [1:0]          {FETCH, EXECUTE} state;
   typedef  logic [ISA-1:0]      itype;
            itype [OP-1:0]       ir;
            itype                instr;
            logic [WIDTHD-1:0]   rt, rn, alu_result; 
            logic [WIDTHA-1:0]   pc, next_pc, sp, sp_next, sp_mem;
            logic [WIDTHS-1:0]   slot, next_slot;
            logic [WIDTHD+1:0]   alu_adder;
            logic [WIDTHD*2-1:0] alu_mult;
            logic [WIDTHD:0]     alu[7:0];
            logic [31:0]         opcode;
            logic [1:0]          opbits;
            logic [2:0]          alu_select;
            logic [1:0]          sf;
            logic                cf, ef, pf, ff, irqf;
            logic                alu_cout, alu_imm, alu_mem, irq_event;
            logic                rt_zero, last_slot, imm_op, alu_done, sp_inc, sp_dec;
            logic                read_complete, write_complete, mem_complete;
            logic                EXT, JSR, JNZ, SWP, POP, PSH, STW, LDW;
            logic                AND, SUB, ADC, ADD, ZEQ, GEQ, ASR, OVR;
            logic                MLT, XOR, IOR;
            logic                PFX, NOP, NUL;
            
   always_comb begin
      writedata = rn;
      read_complete = read & ~waitrequest;
      write_complete = write & ~waitrequest;
      mem_complete = (read_complete | write_complete);
      irq_event = |irq & ~irqf & ~ff & ~pf & ~|sf & ((ISA == 5) ? ~ef : 1'b1);
      instr = ir[slot];
      opbits = (ISA == 6) ? instr[4:3] : {ef, instr[3]};
      PFX = (ISA == 6) ? ~instr[ISA-1] : (~instr[ISA-1] & ~ef);
      opcode = ({31'h0, instr[ISA-1]} << {opbits, instr[2:0]}) & OP_MASK[31:0];
      {EXT, JSR, JNZ, SWP, POP, PSH, STW, LDW} = opcode[7:0];
      {AND, SUB, ADC, ADD, ZEQ, GEQ, ASR, OVR} = opcode[15:8];
      {NUL, NUL, NUL, NUL, NOP, MLT, XOR, IOR} = opcode[23:16];
      {NUL, NUL, NUL, NUL, NUL, NUL, NUL, NUL} = opcode[31:24];
      alu_imm = ASR | ZEQ | MLT | GEQ;
      alu_mem = XOR | IOR | AND | SUB | ADC | ADD;
      imm_op = NUL | NOP | (PFX_PSH ? (PFX & pf) : PFX) | JSR | SWP | alu_imm | (EXT & (ISA == 5));
      rt_zero = ~|rt;
      alu_adder = {1'b0, rn, 1'b1} + {1'b0, (rt ^ {WIDTHD{SUB}}), ((cf & ADC) | SUB)};
      alu_mult = rn[MULT_SIZE-1:0] * rt[MULT_SIZE-1:0];
      alu[0] = {alu_adder[WIDTHD+1]^SUB, alu_adder[WIDTHD:1]}; // unsigned add subtract
      alu[1] = {cf, {WIDTHD{~rt[WIDTHD-1]}}};   // rt >= 0
      alu[2] = {cf, rn & rt};
      alu[3] = {cf, rn | rt};
      alu[4] = {cf, rn ^ rt};
      alu[5] = {cf, {WIDTHD{rt_zero}}};
      alu[6] = {rt[0], rt[WIDTHD-1], rt[WIDTHD-1:1]};
      alu[7] = {cf, ((WIDTHD < WIDTHM) ? alu_mult[WIDTHM-1:WIDTHD] : ZERO[WIDTHD-1:0])};
      alu_select = (ADD | ADC | SUB) ? 3'h0 : GEQ ? 3'h1 : AND ? 3'h2 : IOR ? 3'h3 : XOR ? 3'h4 : ZEQ ? 3'h5 : ASR ? 3'h6 : 3'h7;
      {alu_cout, alu_result} = alu[alu_select];
      last_slot = (slot >= (OP - 1));
      next_pc = pc + last_slot;
      next_slot = last_slot ? ZERO[WIDTHS-1:0] : (slot + ONE[WIDTHS-1:0]);
      sp_inc = (PSH | (PFX_PSH & (PFX & ~pf)) | OVR);
      sp_dec = (POP | JNZ | alu_mem);
      if (state == FETCH) begin
         sp_inc = irq_event;
         sp_dec = 1'b0;
      end
      sp_mem = sp + sp_inc;
      sp_next = sp + {{WIDTHA-1{sp_dec}}, sp_inc|sp_dec};
   end
   generate begin
      if (REGIO == 0) begin
         always_comb begin
            address = sp_mem;
            read = 1'b0;
            write = 1'b0;
            case (state)
               FETCH : 
                  if (irq_event)
                     write = 1'b1;
                  else begin
                     address = pc;
                     read = 1'b1;
                  end
               EXECUTE : begin
                  if (LDW | STW)
                     address = rt[WIDTHA-1:0];
                  read = (LDW | POP | JNZ | alu_mem);
                  write = (STW | PSH | OVR | (PFX_PSH & (PFX & ~pf)));
               end
            endcase
         end
      end
      else begin
         always_ff @ (posedge clock) begin
            if (clock_sreset) begin
               address <= DONTCARE[WIDTHA-1:0];
               read <= 1'b0;
               write <= 1'b0;
            end
            else
               case (state)
                  FETCH : begin
                     address <= irq_event ? sp_mem : pc;
                     read <= irq_event ? 1'b0 : ~read_complete;
                     write <= irq_event ? ~write_complete : 1'b0;
                  end
                  EXECUTE : begin
                     address <= (LDW | STW) ? rt[WIDTHA-1:0] : sp_mem;
                     read <= ~read_complete & (LDW | POP | JNZ | alu_mem);
                     write <= ~write_complete & (STW | PSH | OVR | (PFX_PSH & (PFX & ~pf)));
                  end
               endcase
         end
      end
   end
   endgenerate

   always_ff @ (posedge clock) begin
      if (clock_sreset) begin
         pc <= RESET_ADDR[WIDTHA-1:0];
         sp <= STACK_ADDR[WIDTHA-1:0];
         rt <= DONTCARE[WIDTHD-1:0];
         rn <= DONTCARE[WIDTHD-1:0];
         ir <= DONTCARE[OP*ISA-1:0];
         cf <= DONTCARE[0];
         ef <= 1'b0;
         pf <= 1'b0;
         ff <= 1'b0;
         sf <= 2'b00;
         irqf <= 1'b0;
         slot <= ZERO[WIDTHS-1:0];
         state <= FETCH;
      end
      else begin
         if (mem_complete)
            sp <= sp_next;
         case (state)
            FETCH : begin
               if (read_complete) begin
                  state <= EXECUTE;
                  ir <= readdata[WIDTHI-1:0];
               end
               if (irq_event) begin
                  if (write_complete) begin
                     {pc, slot} <= {IRQ_ADDR[WIDTHA-1:0], ZERO[WIDTHS-1:0]};
                     rt <= {pc, slot};
                     rn <= rt;
                     irqf <= 1'b1;
                  end
               end
               else
                  ff <= 1'b1;
            end
            EXECUTE : begin
               ff <= 1'b0;
               sf <= SWP ? {sf[0], 1'b1} : 2'b00;
               irqf <= (JNZ & ~rt_zero & sf[1]) ? 1'b0 : irqf;
               pf <= PFX_PSH ? (PFX ? (pf ? 1'b1 : write_complete) : 1'b0) : PFX;
               if (NOP | NUL) ;
               if (PFX) begin
                  if (pf) begin
                     rt <= {rt[WIDTHD-ISA:0], instr[ISA-2:0]};
                  end
                  else begin
                     if (PFX_PSH) begin
                        if (write_complete) begin
                           rt <= {{WIDTHD-ISA+1{instr[ISA-2]}}, instr[ISA-2:0]};
                        end
                     end
                     else begin
                        rt <= {{WIDTHD-ISA+1{instr[ISA-2]}}, instr[ISA-2:0]};
                     end
                  end
               end
               if (MLT) rn <= alu_mult[WIDTHD-1:0];
               if (JSR) rt <= {next_pc, next_slot};
               if (alu_imm | (alu_mem & read_complete)) {cf, rt} <= {alu_cout, alu_result};
               if (LDW & read_complete) rt <= readdata;
               if ((POP | JNZ) & read_complete) rt <= rn;
               if ((POP | JNZ | alu_mem) & read_complete) rn <= readdata;
               if ((PSH | (PFX_PSH & (PFX & ~pf))) & write_complete) rn <= rt;
               if ((OVR & write_complete) | SWP) {rt, rn} <= {rn, rt};
               if (imm_op | mem_complete) begin
                  ef <= EXT;
                  {pc, slot} <= (JSR | (JNZ & ~rt_zero)) ? rt[WIDTHP-1:0] : {next_pc, next_slot};
                  if (last_slot | JSR | (JNZ & ~rt_zero))
                     state <= FETCH;
               end
            end
         endcase
      end
   end

endmodule
