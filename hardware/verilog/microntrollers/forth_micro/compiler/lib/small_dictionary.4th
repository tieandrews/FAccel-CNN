( -------------------------------------------------------------------------- )
( stack functions )
macro nip ( a b -- b )           swap drop endmacro
( -------------------------------------------------------------------------- )
( double word functions )
macro 2drop ( d -- )             drop drop endmacro
macro 2dup  ( d -- d d )         over over endmacro
macro d0=   ( d -- ? )           0= swap 0= and endmacro
macro s>d   ( s -- d )           dup 0< endmacro
( -------------------------------------------------------------------------- )
( inequalities )
\ macro 0>=   ( n -- n>=0 )        2* dup xor dup +c endmacro
macro 0<>   ( n -- n!=0 )        0= 0= endmacro
macro <     ( a b -- a>b )       - 0>= 0= endmacro
macro >     ( a b -- a>b )       swap - 0>= 0= endmacro
macro <=    ( a b -- a<=b )      swap - 0>= endmacro
macro >=    ( a b -- a>=b )      - 0>= endmacro
macro 0<    ( x -- x<0 )         0>= 0= endmacro
macro 0>    ( x -- x>0 )         0 > endmacro
macro =     ( a b -- a==b )      xor 0= endmacro
macro <>    ( a b -- a!=b )      = 0= endmacro
macro true  ( -- 1=1 )           0 0= endmacro
macro false ( -- 1=0 )           1 0= endmacro
macro abs   ( n -- |n| )         dup 0>= 0= if negate then endmacro
macro u>    ( a b -- a>b )       u- 0>= endmacro
( -------------------------------------------------------------------------- )
( initial low level macro's )
macro rp@                        __RP @ endmacro
macro rp!                        __RP ! endmacro
macro rp1+ ( -- )                __RP dup @ 1+ swap ! endmacro
macro rp1- ( -- )                __RP dup @ 1- swap ! endmacro
macro r!                         rp@ ! endmacro
macro r@                         rp@ @ endmacro
macro rn@ ( n -- x )             rp@ swap u- @ endmacro
macro rn! ( a b -- )             rp@ swap u- ! endmacro
macro rp+ ( n -- )               rp@ u+ rp! endmacro
macro rp- ( n -- )               rp@ swap u- rp! endmacro
macro shr   ( n -- 0>>n>>1 )     2/ __msbit @ not and endmacro
macro set_bits ( n b -- n|b )    or endmacro
macro clear_bits ( n b -- n&~b ) not and endmacro
macro flip_bits ( n b -- n^b )   xor endmacro
( -------------------------------------------------------------------------- )
( execution flow )
macro "do" struct "do" "loop" swap 2>r label do.start do_loop_test addr do.end and jump endmacro
macro "loop" do_loop_inc addr do.start jump label do.end 2 rp- endstruct "do" endmacro
macro "loop+" do_loop_inc addr do.start jump label do.end 2 rp- endstruct "do" endmacro
macro "leave" addr do.end jump endmacro
macro "i" r@ endmacro
macro "j" 2 rn@ endmacro
macro "k" 4 rn@ endmacro
macro "case" struct "case" "endcase" >r endmacro
macro "of" struct "of" "endof" r@ <> addr of.end and jump endmacro
macro "endof" addr case.end jump label of.end endstruct "of" endmacro
macro "endcase" label case.end rp1- endstruct "case" endmacro
macro cells ( addr1 -- addr2 ) endmacro
macro chars ( c -- a_addr ) __CHARSPERWORD / endmacro
macro cell+ ( addr1 -- addr2 ) 1 u+ endmacro
macro char+ ( c_addr1 -- c_addr2 ) 1 u+ endmacro
( -------------------------------------------------------------------------- )
( low level functions )
: >r ( n -- ) swap carry swap rp1+ r! load_carry ;   \ carry preserved
: r> ( -- n ) carry r@ rp1- swap load_carry swap ;   \ carry preserved
: 2>r ( a b -- ) swap rp@ 1 u+ ! swap rp@ 2 u+ store rp! drop ;
: rot ( a b c -- b c a ) 2>r swap r> swap r> ;
: n>r ( a b ... z n -- ) swap begin rot >r dup 0= if true else 1- false then until drop ;
: do_loop_test ( -- t/f ) rp@ dup 1 u- @ swap @ <= swap ;
: do_loop_inc ( -- ) rp@ dup @ 1 u+ swap ! ;
: -rot ( a b c -- c a b ) >r swap r> swap r> r> ;
: call_tick ( addr rate var -- ) >r dup @ rot >= if 0 swap ! call else dup @ 1+ swap ! drop then r> ;
: wait_var ( value var -- ) >r dup 0 swap ! begin over over @ swap >= until drop drop r> ;

macro d+ ( da db -- da+db ) >r swap >r u+ r> r> u+c endmacro
( -------------------------------------------------------------------------- )
macro __SYSTEM_INIT ( -- )
   __RSTACK rp!
endmacro

