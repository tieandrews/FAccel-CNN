: divmod \ a b -- a/b a%b
   >r dup 1 0 >r >r >r >r >r
   begin 2 rn@ r@ < while
      2 rn@ 2* 2 rn!
      3 rn@ 2* 3 rn!
   repeat
   begin r@ 1 rn@ >= while
      2 rn@ r@ <= if
         4 rn@ 3 rn@ + 4 rn!
         r@ 2 rn@ - r!
      then
      2 rn@ 2/ 2 rn!
      3 rn@ 2/ 3 rn!
   repeat
   4 rn@ r@
   5 rp- r> ;
: / ( a b -- a/b ) >r dup 0= if nip else divmod drop then r> ;
: mod ( a b -- a%b ) dup 0<> if divmod then nip r> ;
\ ----------------------------------------------------------------------------
: u*_dshl >r swap dup u+ swap carry swap 2* u+ r> ;
: u*_ndshl >r >r begin u*_dshl r@ 1- dup r! 0= until 1 rp- r> ;
: u*_ror >r shr [ __MULTSIZE 1 - ] begin swap 2/ swap 1- dup 0= until drop r> ;
: u* ( ua ub -- multl multh ) >r __MULTSIZE __DATAPATH >= if umult else >r >r
   r@ 1 rn@ umult 1 rn@ r@ u*_ror umult __MULTSIZE u*_ndshl d+
   r@ 1 rn@ u*_ror umult __MULTSIZE u*_ndshl d+ r@ u*_ror 1 rn@ u*_ror umult
   [ __MULTSIZE 2* ] u*_ndshl d+ 2 rp- then r> ;   
\ ----------------------------------------------------------------------------
