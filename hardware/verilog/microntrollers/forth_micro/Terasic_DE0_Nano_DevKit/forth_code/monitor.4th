( microcontroller hardware settings )
32 constant .opcode_word_size
5 constant .opcode_instruction_size
6 constant .opcode_instructions_per_word
3 constant .opcode_sub_word_slot_bits

( -------------------------------------------------------------------------- )
( ram addresses $0 to $f )
0 org
variable crc

$700 allot ( other variables in RAM )
( stack $7e0 to $7ff )

( -------------------------------------------------------------------------- )
[ $10 6 * ] org ( 0x10 * opcodes per word )
addr .__SYSIRQ__ jump ( JUMP to IRQ service routine )

[ $14 6 * ] org ( 0x14 * opcodes per word )
addr .__MAIN_CODE__ jump   ( JUMP to code start )

( -------------------------------------------------------------------------- )
( hardware base addresses for peripherals )
$000 constant RAM_BASE
$800 constant JTAG_BASE
$810 constant PORT0_BASE
$820 constant TIMER0_BASE
$830 constant UART0_BASE
$840 constant ONEWIRE0_BASE
$1000000 constant SDRAM_BASE

( -------------------------------------------------------------------------- )
( declare variables 0x700 )
variable __RP ( 128 layer stack ) 128 allot
variable MAXBIT
variable ARCHITECTURE

( -------------------------------------------------------------------------- )
( create synthetic return stack and fast code )
:: >r ( n -- ) swap carry swap __RP @ 1 + __RP store drop ! pop_carry ;;
:: r> ( -- n ) carry __RP @ dup 1 - __RP ! @ swap pop_carry swap ;;
:: __loop_test ( -- t/f ) __RP @ dup 1 - @ swap @ >= swap ;;
:: __loop_inc ( -- ) __RP @ 1 - dup @ 1 + swap ! ;;
:: __rp2drop ( -- ) __RP dup @ 2 - swap ! ;;
: lshift ( n d -- n<<d ) begin dup 0<> while 1 - swap 2* swap repeat drop ;
: rshift ( n d -- n>>d ) begin dup 0<> while 1 - swap 2/ swap repeat drop ;
:: ralloc ( n -- ) swap __RP @ + __RP ! ;;
:: rrelease ( n -- ) swap __RP @ - __RP ! ;;
( -------------------------------------------------------------------------- )
:: __SYSTEM_INIT
   0 1 begin swap 1 + swap 2* 0 dup +c 0<> until drop ARCHITECTURE !
   1 ARCHITECTURE @ 1 - lshift MAXBIT !
;;
( -------------------------------------------------------------------------- )
: temp 0 drop ;
( -------------------------------------------------------------------------- )
:: onewire_wait_busy ( -- ) begin ONEWIRE0_BASE @ $2 and 0= until ;;
( -------------------------------------------------------------------------- )
:: onewire_drive_high ( -- ) onewire_wait_busy $1 [ ONEWIRE0_BASE 2 + ] ! ;;
:: onewire_drive_low ( -- ) onewire_wait_busy $0 [ ONEWIRE0_BASE 2 + ] ! ;;
:: onewire_drive_z ( -- ) onewire_wait_busy $2 [ ONEWIRE0_BASE 2 + ] ! ;;
( -------------------------------------------------------------------------- )
:: onewire_reset ( -- t/f )
   $0 ONEWIRE0_BASE ! onewire_wait_busy ONEWIRE0_BASE @ $4 and 0<> swap ;;
( -------------------------------------------------------------------------- )
:: onewire_write_bit ( n -- ) swap $1 and 0= if $1 else $2 then
   ONEWIRE0_BASE ! onewire_wait_busy ;;
( -------------------------------------------------------------------------- )
:: onewire_read_bit ( -- n ) $3 ONEWIRE0_BASE ! onewire_wait_busy
   [ ONEWIRE0_BASE 1 + ] @ swap ;;
( -------------------------------------------------------------------------- )
:: onewire_send_byte ( n -- ) swap 8 0 do dup onewire_write_bit 2/ loop drop ;;
( -------------------------------------------------------------------------- )
:: onewire_read_byte ( -- n )
   $0 8 0 do 2/ onewire_read_bit 0<> if $80 else $0 then or loop swap ;;
( -------------------------------------------------------------------------- )
:: onewire_skip_rom ( -- ) $cc onewire_send_byte ;;
( -------------------------------------------------------------------------- )
:: onewire_read_rom ( -- ) $33 onewire_send_byte ;;
( -------------------------------------------------------------------------- )
:: onewire_convert_temp ( -- ) $44 onewire_send_byte ;;
( -------------------------------------------------------------------------- )
:: onewire_read_scratch ( -- ) $be onewire_send_byte ;;
( -------------------------------------------------------------------------- )
:: onewire_read_word16 ( -- n )
   onewire_read_byte onewire_read_byte 8 lshift or swap ;;
( -------------------------------------------------------------------------- )
:: onewire_start_temp ( -- ) onewire_reset drop
   onewire_skip_rom onewire_convert_temp ;;
( -------------------------------------------------------------------------- )
:: onewire_read_temp ( -- t ) onewire_reset drop onewire_skip_rom
   onewire_read_scratch onewire_read_word16 swap ;;
( -------------------------------------------------------------------------- )
: onewire_crc8 ( crc n -- crc )
   xor 8 0 do
      dup 1 and if 2/ $8c xor else 2/ then
   loop ;
( -------------------------------------------------------------------------- )
:: asr5 ( n -- n>>5 ) swap 2/ 2/ 2/ 2/ 2/ swap ;;
( -------------------------------------------------------------------------- )
:: jtag_send_check ( -- ) begin [ JTAG_BASE 1 + ] @ asr5 $ff and 4 > until ;;
( -------------------------------------------------------------------------- )
:: jtag_send ( char -- ) swap jtag_send_check JTAG_BASE ! ;;
( -------------------------------------------------------------------------- )
:: jtag_wait_char ( -- char ) 0 begin drop JTAG_BASE @ dup $100 and 0<>
   until $ff and swap ;;
( -------------------------------------------------------------------------- )
:: emit ( char -- ) swap jtag_send ;;
( -------------------------------------------------------------------------- )
:: make_hex_digit ( n -- ascii ) swap $f and dup 9 > if 55 else 48 then + swap ;;
( -------------------------------------------------------------------------- )
: showhex ( n digits -- )
   dup 0 do
      dup 1 - i - 4* swap >r over swap rshift
      make_hex_digit emit r>
   loop 2drop ;
( -------------------------------------------------------------------------- )
:: pow10 ( n -- 10^n ) swap 1 swap 0 do 10 * drop loop swap ;;
:: showdec3 ( n -- )
   swap $0 swap
   begin dup 100 >= while 100 - swap 1 + swap repeat
   swap $30 + emit
   $0 swap 
   begin dup 10 >= while 10 - swap 1 + swap repeat
   swap $30 + emit
   $30 + emit ;;
( -------------------------------------------------------------------------- )
:: crlf ( -- ) $d emit $a emit ;;
( -------------------------------------------------------------------------- )
:: msg_ok ( -- ) $6b $4f emit emit ;;
( -------------------------------------------------------------------------- )
:: msg_? ( -- ) $3f emit ;;
( -------------------------------------------------------------------------- )
:: msg_temp ( "Temp:" ) $3a $70 $6d $65 $54 5 0 do emit loop ;;
( -------------------------------------------------------------------------- )
:: msg_degs ( "degs" ) $73 $67 $65 $64 4 0 do emit loop ;;
( -------------------------------------------------------------------------- )
:: msg_yes ( "yes" ) $73 $65 $59 3 0 do emit loop ;;
( -------------------------------------------------------------------------- )
:: msg_no ( "no" ) $6f $4e emit emit ;;
( -------------------------------------------------------------------------- )
:: show_temp ( n -- ) swap dup 2/ showdec3 $2e emit
   1 and 0<> if $35 else $30 then emit ;;
( -------------------------------------------------------------------------- )
:: wait_1_second 600000 0 do 0 drop loop ;;

( -------------------------------------------------------------------------- )
:: onewire_read_rom_info ( -- )
   ( read ROM information with CRC )
   onewire_reset drop
   onewire_read_rom
   0 crc !
   7 0 do
      onewire_read_byte dup showhex 1 $20 emit
      crc @ swap onewire_crc8 crc !
   loop crlf
   onewire_read_byte crc @ = if msg_yes else msg_no then crlf ;;

: count_digit ( n x -- )
   0 >r
   begin
      over over - dup 0>= dup
      if r> 1 + >r >r >r swap drop r> swap r> then
      not
   until r> ;

: showdec ( n digits -- )
   dup 0 do
      dup 1 - i - 4* swap >r over swap rshift
      make_hex_digit emit r>
   loop 2drop ;
:: 2>r ( aa -- ) swap >r swap >r ;;
:: 2r> ( -- aa ) r> swap r> swap ;;
: d+ ( aa bb -- aa+bb ) swap >r + swap r> +c swap ;
: d= ( aa bb -- t/f ) rot = >r = r> = ;
: d> ( d1 d2 -- t/f ) rot > -rot  > and ;
: 2swap ( aa bb -- bb aa ) r> swap r> swap r> r> -rot ;
: 2over ( aa bb -- aa bb aa ) 2swap 2dup 2>r 2swap 2r> ;
: u< ( a b -- t/f ) 2dup xor 0< if swap drop 0< exit then - 0< ;
: max ( a b -- a:b ) 2dup < if swap then drop ;
: min ( a b -- a:b ) 2dup swap < if swap then drop ;
:: _r ( n -- rp-n ) swap __RP - 1 + swap ;;
: DivMod \ a b -- a/b a%b
            Dup 1 0 
            5 ralloc \ _R1_ is a, _R2_ is b, _R5_ _R1_ is result
            
            Begin 3 _r @ 1 _r @ < While
                3 _r @ 2* 3 _r !
                4 _r @ 2* 4 _r !
            Repeat
            Begin 1 _r @ 2 _r @ >= While
                3 _r @ 1 _r @ <= If
                    5 _r @ 4 _r @ + 5 _r !
                    1 _r @ 3 _r @ - 1 _r !
                Then
                3 _r @ 2/ 3 _r !
                4 _r @ 2/ 4 _r !
            Repeat
            5 _r @ 1 _r @
            5 rrelease 
        ;
( -------------------------------------------------------------------------- )
: s>d ( n -- d ) dup 0 < if dup else 0 then ;
: 8>32 ( n -- n' ) \ sign extend 8 bit number to 32 bit
   dup $80 and if $ffffff00 or then ;
: 24>32 ( n -- n') \ sign extend a 24 bit number to 32 bits
   dup $800000 and if $ff000000 or then ;
: fp_pack ( n-sigf n-exp -- f ) $18 lshift swap $ffffff and or ;
: fp_unpack ( f -- n-sigf n-exp ) dup $ffffff and 24>32 swap $18 rshift 8>32 ;
: d10* ( d1 -- d2 ) 2dup d2* d2* d+ d2* ; \ mult double by 10

( -------------------------------------------------------------------------- )
( Main code starts here )
label .__MAIN_CODE__
__RP dup ! ( set RP pointer )
__SYSTEM_INIT
( -------------------------------------------------------------------------- )

onewire_drive_z

ARCHITECTURE @ showdec3 crlf
MAXBIT @ 8 showhex crlf

begin ( spin here )
   PORT0_BASE dup @ 1 xor swap !
again

( -------------------------------------------------------------------------- )
( IRQ handling routine - all IRQ's come here first )
label .__SYSIRQ__
   $1 [ UART0_BASE 3 + ] !
   reti
