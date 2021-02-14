( ************************************************************************** )
50000000    constant SYSTEM_CLOCK
50000       constant ONE_KHZ     \ in system clock cycles
( ************************************************************************** )
20          constant __DATAPATH
5           constant __NIBBLES
18          constant __MULTSIZE
5           constant __ISA    \ must be 5 for FORTH (limitation)
4           constant __SLOTS
2           constant __SLOTBITS
( ************************************************************************** )
( hardware base addresses for peripherals )
$000        constant RAM_BASE
$800        constant JTAG_BASE
$810        constant PORT0_BASE
$820        constant TIMER0_BASE
( ************************************************************************** )
__DATAPATH  constant .opcode_word_size
__ISA       constant .opcode_instruction_size
__SLOTS     constant .opcode_instructions_per_word
__SLOTBITS  constant .opcode_sub_word_slot_bits
( ************************************************************************** )
( ram addresses $0 to $f )
0 org
variable __RP
variable __msbit
variable __jtag_char
[ $700 3 - ] allot            \ other variables at $700
variable __RSTACK 32 allot    \ 32 words of rstack at $700
variable timer_flag
variable timer_tick

( ************************************************************************** )
[ $10 __SLOTS /mlt ] org      \ 0x10 * opcodes per word
addr .__SYSIRQ__ jump         \ Vector to IRQ service routine
[ $14 __SLOTS /mlt ] org      \ 0x14 * opcodes per word 
addr .__MAIN_CODE__ jump      \ Jump to code start
( ************************************************************************** )
include "..\..\..\..\forth\small_dictionary.4th"
include "..\..\..\..\forth\math.4th"
include "..\..\..\..\forth\logic.4th"
( ************************************************************************** )
( -------------------------------------------------------------------------- )
( hardware dependant code )
: jtag_key? ( -- t/f ) JTAG_BASE @ dup $ff and __jtag_char ! $100 and 0<> swap ;
: jtag_send_check ( -- ) begin [ JTAG_BASE 1 + ] @ 32/ $ff and 4 > until ;
: jtag_wait_char ( -- char ) begin jtag_key? until __jtag_char @ swap ;
: jtag_send ( char -- ) swap jtag_send_check JTAG_BASE ! ;
macro emit ( char -- ) jtag_send endmacro
macro key ( -- char ) jtag_wait_char endmacro
macro key? ( -- t/f ) jtag_key? endmacro
( -------------------------------------------------------------------------- )
macro timer_set_counter ( n -- ) [ TIMER0_BASE 1 + ] ! endmacro
macro timer_set_reload ( n -- ) [ TIMER0_BASE 2 + ] ! endmacro
macro timer_irq_ack ( -- ) 1 [ TIMER0_BASE 3 + ] ! endmacro
macro timer_init ( -- ) timer_reload_disable timer_irq_disable timer_disable endmacro
: timer_reload_enable ( -- ) TIMER0_BASE dup @ 4 set_bits swap ! ;
: timer_reload_disable ( -- ) TIMER0_BASE dup @ 4 clear_bits swap ! ;
: timer_enable ( -- ) TIMER0_BASE dup @ 1 set_bits swap ! ;
: timer_disable ( -- ) TIMER0_BASE dup @ 1 clear_bits swap ! ;
: timer_irq_enable ( -- ) TIMER0_BASE dup @ 2 set_bits swap ! ;
: timer_irq_disable ( -- ) TIMER0_BASE dup @ 2 clear_bits swap ! ;
( -------------------------------------------------------------------------- )
macro led_init ( -- ) led_on led_off endmacro
: led_on ( -- ) PORT0_BASE dup @ 1 set_bits swap ! ;
: led_off ( -- ) PORT0_BASE dup @ 1 clear_bits swap ! ;
: led_flop ( -- ) PORT0_BASE dup @ 1 flip_bits swap ! ;
( ************************************************************************** )
include "..\..\..\..\forth\user_interface.4th"
\ include "..\..\..\..\forth\onewire.4th"
( ************************************************************************** )
( ************************************************************************** )
( Main code starts here )
( ************************************************************************** )
label .__MAIN_CODE__
   __SYSTEM_INIT
( ************************************************************************** )
0 timer_flag !
0 timer_tick !
timer_init led_init
[ ONE_KHZ 1 - ] dup timer_set_counter timer_set_reload
timer_reload_enable timer_irq_enable timer_disable
led_off
begin
   [char] ":" emit
   key upper_case dup emit crlf
   case
      [char] "M" of
         0 16 0 do
            dup showhex [char] ":" emit
            8 0 do
               dup @ showhex [char] " " emit 1 +
            loop crlf
         loop drop crlf         
      endof
      [char] "T" of
         timer_flag @ 0= if
            1 timer_flag !
            [char] "O" emit [char] "n" emit crlf
            timer_enable
         else
            0 timer_flag !
            [char] "O" emit [char] "f" emit [char] "f" emit crlf
            timer_disable
            led_off
         then
      endof
      [char] "?" emit crlf
   endcase
again

( ************************************************************************** )
( IRQ handling routine - all IRQ's come here first )
label .__SYSIRQ__
   timer_irq_ack
   timer_tick @ 999 >= if
      0 timer_tick !
      led_flop
   else
      timer_tick dup @ 1+ swap !
   then
   reti
( ************************************************************************** )
