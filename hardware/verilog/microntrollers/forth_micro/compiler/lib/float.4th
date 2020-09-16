( -------------------------------------------------------------------------- )
( This is not IEEE float it is signed exponent signed mantissa )
( work in progress )
: sext_exp ( n -- n' ) \ sign-extend the exponent to a full word
   dup 1 [ __FLT_EXP 1 - ] lshift and 0<> __FLT_EXP lshift or ;
: sext_mant ( n -- n' ) \ sign extend the mantissa
   dup 1 [ __FLT_MANT 1 - ] lshift and 0<> __FLT_MANT lshift or ;
: pack ( n-sig n-exp -- f ) \ pack significand and exponent to a floating point number
  __FLT_MANT lshift swap -1 __FLT_EXP rshift and or ;                          
: unpack ( f -- n-sig n-exp ) \ unpack floating point number to significand and exponent
   dup -1 __FLT_EXP rshift and sext_mant swap __FLT_MANT rshift sext_exp ;
