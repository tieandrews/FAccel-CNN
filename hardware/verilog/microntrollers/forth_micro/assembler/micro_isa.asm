   /***************************************************************************/
   /* opcode definition                                                       */
   /* DATAPATH and ISA defined at top level                                   */
   /* code_ptr and var_ptr set at top level for code destination              */
   /***************************************************************************/
   /*
   ISA5     MSBIT 0 PFX 0x0..0xF
   ISA6     MSBIT 0 PFX 0x0..0x1F

            MSBITS ISA5/6
                        EXT   EXT
   ISA5      10    11    10    11
   ISA6     100   101   110   111
            ---------------------
   000      LDW   OVR   AND
   001      STW   ASR   XOR
   010      PSH   GEQ   MLT
   011      POP   ZEQ   NOP
   100      SWP   ADD 
   101      JNZ   ADC
   110      JSR   SUB
   111     (EXT)  NOP
   */
   OP_GROUP0 = 0x10; /* ISA5 default */
   OP_GROUP1 = 0x0;
   PFX_BITS = (ISA - 1);
   PFX_MASK = ((1 << PFX_BITS) - 1);
   PFX_MAX = ((1 << (PFX_BITS - 1)) - 1);
   ISA_MASK = ((1 << ISA) - 1);
   OPCODE_SLOTS = (DATAPATH / ISA);
   #define calc_slotsize /* calculate log base 2 */
   {
      calc_log = 0;
      calc_total = (OPCODE_SLOTS - 1);
      while (calc_total > 0) {
         calc_total = calc_total >> 1;
         calc_log = calc_log + 1;
      }
      SLOT_BITS = calc_log;
   }
   calc_slotsize;
   #define lbl n { n = ((code_ptr << SLOT_BITS) | slot_ptr); }
   #define var n { n = var_ptr; out var_ptr, 0; }
   #define var_alloc n { var_ptr = var_ptr + n; }

   #if (ISA == 6) { OP_GROUP0 = 0x20; OP_GROUP1 = 0x30; }
   
   slot_ptr = 0;
   opcode_word = 0;
   pfx_last = 0;
   
   #if (pass == 0) /* first pass of the assembler */
   {
      #define flush_opcodes
      {
         #if (slot_ptr > 0) { out code_ptr, opcode_word; }
         slot_ptr = 0;
      }
      #define add_opcode n
      {
         opcode_word = (opcode_word | ((n & ISA_MASK) << (slot_ptr * ISA)));
         slot_ptr = slot_ptr + 1;
         #if (slot_ptr >= OPCODE_SLOTS)
         {
            out code_ptr, opcode_word;
            slot_ptr = 0;
            opcode_word = 0;
         }
      }
      
      #define PFX n { add_opcode (n & PFX_MASK); }
      
      #define LDW { add_opcode (OP_GROUP0 + 0x0); pfx_last = 0; }
      #define STW { add_opcode (OP_GROUP0 + 0x1); pfx_last = 0; }
      #define PSH { add_opcode (OP_GROUP0 + 0x2); pfx_last = 0; }
      #define POP { add_opcode (OP_GROUP0 + 0x3); pfx_last = 0; }
      #define SWP { add_opcode (OP_GROUP0 + 0x4); pfx_last = 0; }
      #define JNZ { add_opcode (OP_GROUP0 + 0x5); pfx_last = 0; }
      #define JSR { add_opcode (OP_GROUP0 + 0x6); pfx_last = 0; }
      #define EXT { add_opcode (OP_GROUP0 + 0x7); pfx_last = 0; }
      
      #define OVR { add_opcode (OP_GROUP0 + 0x8); pfx_last = 0; }
      #define ASR { add_opcode (OP_GROUP0 + 0x9); pfx_last = 0; }
      #define GEQ { add_opcode (OP_GROUP0 + 0xa); pfx_last = 0; }
      #define ZEQ { add_opcode (OP_GROUP0 + 0xb); pfx_last = 0; }
      #define ADD { add_opcode (OP_GROUP0 + 0xc); pfx_last = 0; }
      #define ADC { add_opcode (OP_GROUP0 + 0xd); pfx_last = 0; }
      #define SUB { add_opcode (OP_GROUP0 + 0xe); pfx_last = 0; }
      #define NOP { add_opcode (OP_GROUP0 + 0xf); pfx_last = 0; }
      
      #define AND { #if (ISA == 5) { EXT; } add_opcode (OP_GROUP1 + 0x0); pfx_last = 0; }
      #define IOR { #if (ISA == 5) { EXT; } add_opcode (OP_GROUP1 + 0x1); pfx_last = 0; }
      #define XOR { #if (ISA == 5) { EXT; } add_opcode (OP_GROUP1 + 0x2); pfx_last = 0; }
      #define MLT { #if (ISA == 5) { EXT; } add_opcode (OP_GROUP1 + 0x3); pfx_last = 0; }
      
      #define prefix_positive n
      {
         #if (pfx_last == 1) { NOP; }
         pfx_last = 1;
         prefix_slot = (DATAPATH / (ISA - 1));
         first_slot = 1;
         while (prefix_slot > 0)
         {
            prefix_bits = (n & (PFX_MASK << (PFX_BITS * (prefix_slot - 1))));
            prefix_bits = (prefix_bits >> (PFX_BITS * (prefix_slot - 1)));
            #if ((first_slot == 1) && (prefix_bits != 0)) {
               #if (prefix_bits > PFX_MAX) { PFX 0; }
               first_slot = 0;
            } 
            #if (first_slot == 0) { PFX prefix_bits; }
            prefix_slot = prefix_slot - 1;
         }
         #if (first_slot == 1) { PFX 0; }
      }
      #define prefix_negative n
      {
         #if (pfx_last == 1) { NOP; }
         pfx_last = 1;
         prefix_slot = (DATAPATH / (ISA - 1));
         first_slot = 1;
         while (prefix_slot > 0)
         {
            prefix_bits = (n & (PFX_MASK << (PFX_BITS * (prefix_slot - 1))));
            prefix_bits = (prefix_bits >> (PFX_BITS * (prefix_slot - 1)));
            #if ((first_slot == 1) && (prefix_bits != PFX_MASK)) {
               first_slot = 0;
            } 
            #if (first_slot == 0) { PFX prefix_bits; }
            prefix_slot = prefix_slot - 1;
         }
         #if (first_slot == 1) { PFX PFX_MASK; }
      }
      #define prefix n { #if (n < 0) { prefix_negative n; } #if (n >= 0) { prefix_positive n; } }
      #define push n { #if (argc > 0) { prefix n; } #if (argc == 0) { psh; } }
   }
   /* define registers */
   r0 = 0; r1 = 1; r2 = 2; r3 = 3; r4 = 4; r5 = 5; r6 = 6; r7 = 7;
   r8 = 8; r9 = 9; r10 = 10; r11 = 11; r12 = 12; r13 = 13; r14 = 14; r15 = 15;
   #if (ISA == 6) /* define extra registers */
   {
      r16 = 16; r17 = 17; r18 = 18; r19 = 19; r20 = 20; r21 = 21; r22 = 22; r23 = 23;
      r24 = 24; r25 = 25; r26 = 26; r27 = 27; r28 = 28; r29 = 29; r30 = 30; r31 = 31;
   }
