( microcontroller hardware settings )
32 constant .opcode_word_size
5 constant .opcode_instruction_size
6 constant .opcode_instructions_per_word
2 constant .opcode_sub_word_slot_bits

( -------------------------------------------------------------------------- )
( ram addresses $0 to $1f )
0 org
variable counter

( -------------------------------------------------------------------------- )
$180 allot ( heap in RAM )

96 org ( 0x10 * 6 )
addr .__SYSIRQ__ jump ( JUMP to IRQ service routine )

label .Placeholder
[ 120 ] org ( 0x14 * 6 )
label .Placeholder
addr .__MAIN_CODE__ jump   ( JUMP to code start )


( -------------------------------------------------------------------------- )
( hardware base addresses for peripherals )
$200 constant PORT0_BASE
$210 constant TIMER0_BASE

( -------------------------------------------------------------------------- )
variable __RP 16 allot
( create synthetic return stack - 16 levels )
:: >r ( n -- ) swap __RP @ 1 + __RP store drop ! ;;
:: r> ( -- n ) __RP @ dup 1 - __RP ! @ swap ;;

( -------------------------------------------------------------------------- )
: led_flop ( ) PORT0_BASE @ 1 xor PORT0_BASE ! ;
: set_timer ( n -- ) dup [ TIMER0_BASE 1 + ] ! [ TIMER0_BASE 2 + ] ! ;
: run_timer ( n -- ) TIMER0_BASE ! ;
:: clear_timer_irq ( ) 1 [ TIMER0_BASE 3 + ] ! ;;
:: dec ( n -- ) swap dup @ 1 - swap ! ;;

( -------------------------------------------------------------------------- )
( Main code starts here )
label .__MAIN_CODE__
__RP dup ! ( set RP pointer )
( -------------------------------------------------------------------------- )
3 constant END_COUNT
$100 set_timer $7 run_timer
END_COUNT counter !
   
   
   
begin ( spin here )
again

( -------------------------------------------------------------------------- )
( IRQ handling routine - all IRQ's come here first )
label .__SYSIRQ__
push_carry
clear_timer_irq
   
counter @ 0=
if
   END_COUNT counter ! led_flop
else
   counter dec
then
   
pop_carry
reti

