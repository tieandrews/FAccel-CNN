: make_hex_digit ( n -- char ) swap $f and dup 10 < if $30 else 55 then u+ swap ;
: crlf ( -- ) $d emit $a emit ;
: upper_case ( char -- CHAR ) swap dup $61 >= if $df and then swap ;
: showhex ( n -- ) swap __NIBBLES begin swap dup make_hex_digit >r 16/ swap 1- dup 0= until
   2drop __NIBBLES begin r> emit 1- dup 0= until drop ;
: showhexbyte ( n -- ) swap $ff and 2 begin swap dup make_hex_digit >r 16/ swap 1- dup 0= until
   2drop __NIBBLES begin r> emit 1- dup 0= until drop ;
: . ( n -- ) swap 0 swap dup 0 < if [char] "-" emit negate then begin
   swap 1+ swap 10 divmod >r dup 0= until drop begin r> [char] "0" + emit
   1- dup 0= until drop ;
: ishexdigit ( char -- t/f ) swap upper_case dup $30 >= swap dup $39 <=
   swap >r and r> dup $41 >= swap $46 <= and or swap ;
: gethexdigit ( -- char/t/f ) swap 
   begin
      key dup
      case
         27 of
            drop false true
         endof
         dup ishexdigit if
            true
         else
            drop false
         then
      endcase
   until swap ;
