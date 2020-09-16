( -------------------------------------------------------------------------- )
( (re)define 5 bit opcodes )
   $10         Constant    .LDW ( load word )
   $11         Constant    .STW ( store word )
   $12         Constant    .PSH  ( push stack )
   $13         Constant    .POP ( pop stack )
   $14         Constant    .SWP ( swap )
   $15         Constant    .JNZ ( jump if TOS is zero )
   $16         Constant    .JSR 
   $18         Constant    .RTO ( ovr - hack )
   $19         Constant    .LSR ( asr - hack - arith shift right )
   $1a         Constant    .TOR ( geq - hack - test greater than or equal to )
   $1b         Constant    .ZEQ 
   $1c         Constant    .ADD 
   $1d         Constant    .ADC 
   $1e         Constant    .SUB 
   $1f         Constant    .AND 
   [ $17 $10 ] 2Constant   .IOR 
   [ $17 $11 ] 2Constant   .XOR
   [ $17 $12 ] 2Constant   .MLT
( -------------------------------------------------------------------------- )
( opcode renaming )
( /pfx is 0x0 to 0x1f )
macro @     ( a -- m[a] )        /ldw endmacro 
macro store ( a n -- a n )       /stw endmacro 
macro drop  ( a -- )             /pop endmacro 
macro dup   ( a -- )             /psh endmacro 
macro swap  ( a b -- b a )       /swp endmacro 
macro jump  ( n -- )             /jnz endmacro
macro call  ( n -- pc,s )        /jsr endmacro 
macro and   ( a b -- a&b )       /and endmacro 
macro or    ( a b -- a-b,c )     /ior endmacro 
macro xor   ( a b -- a^b )       /xor endmacro 
macro 2/    ( a -- a>>>1,c )     /lsr endmacro 
macro 0=    ( a -- a==0 )        /zeq endmacro 
macro u+c   ( a b -- b+a+c )     /adc endmacro 
macro u+    ( a b -- a+b,c )     /add endmacro 
macro u-    ( a b -- a-b,c )     /sub endmacro 
macro umult ( a b -- LO HI )     /mlt endmacro 
macro 0>= 	( a b -- a>=b )      /tor endmacro ( keywords I have left - hack )
macro over 	( a b -- a b a )     /rto endmacro ( keywords I have left - hack )
( can use LSP RSP )
( -------------------------------------------------------------------------- )
( useful functions )
macro +     ( a b -- a+b,c )     u+ endmacro \ for now
macro +c    ( a b -- a+b,c )     u+c endmacro \ for now
macro -     ( a b -- a-b,c )     u- endmacro \ for now
macro !     ( n a -- )           store drop drop endmacro
macro ret   ( r -- )             jump endmacro
macro reti  ( r -- )             swap swap ret endmacro
macro not   ( n -- ~n )          -1 xor endmacro
macro negate ( n -- -n )         0 swap - endmacro
macro 1-    ( n -- n-1 )         1 - endmacro
macro 1+    ( n -- n-1 )         1 + endmacro
macro 2*    ( n -- n*2 )         dup + endmacro
macro 4*    ( n -- n*4 )         2* 2* endmacro
macro 8*    ( n -- n*8 )         2* 4* endmacro
macro 16*   ( n -- n*4 )         4* 4* endmacro
macro 256*  ( n -- n*4 )         16* 16* endmacro
macro 3*    ( n -- 3*n )         dup 2* + endmacro
macro 4/    ( n -- n/4 )         2/ 2/ endmacro
macro 16/   ( n -- n/16 )        4/ 4/ endmacro
macro 32/   ( n -- n/16 )        4/ 4/ 2/ endmacro
macro 256/  ( n -- n/256 )       16/ 16/  endmacro
macro load_carry ( -- )          2/ drop endmacro
macro clear_carry   ( -- )       0 load_carry endmacro
macro set_carry ( -- )           1 load_carry endmacro
macro carry ( -- c )             0 dup +c endmacro
( -------------------------------------------------------------------------- )
( execution flow )
macro ":" isdefinition struct definition ";" label {Label} endmacro   \ needs? caps Label
macro ";" ret endstruct definition endmacro
macro "if" struct "if" "then" 0= addr if.end and jump endmacro
macro "else" addr if.endelse jump label if.end endmacro
macro "then" label if.endelse label if.end endstruct "if" endmacro
macro "begin" struct "begin" "again/until/repeat" label begin.start endmacro
macro "again" addr begin.start jump endstruct "begin" endmacro
macro "until" 0= addr begin.start and jump endstruct "begin" endmacro
macro "while" struct "while" "repeat" 0= addr while.end and jump endmacro
macro "repeat" addr begin.start jump label while.end endstruct "while" endstruct "begin" endmacro

