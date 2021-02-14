// bfloat16 helper functions

#ifndef __BFLOAT16_H
    #define __BFLOAT16_H

    #include "nios_alt_types.h"

    ////////////////////////////////////////////////////////////////////////////////
    union int_float {  alt_u32 i;  float f;  };
    typedef alt_u16 bfloat16;

    float bf2f(bfloat16 x) { // bfloat to float
         union int_float f;
         f.i = ((alt_u32)x << 16);
         return f.f;
    }
    bfloat16 f2bf(float x) { // float to bfloat
         union int_float f;
         f.f = x;
         return (bfloat16)(f.i >> 16);
    }

    //////////////////////////////////////////////////////////////////////////////
    bfloat16 bf_mult(bfloat16 a, bfloat16 b) {
         return f2bf(bf2f(a) * bf2f(b));
    }

    //////////////////////////////////////////////////////////////////////////////
    bfloat16 bf_add(bfloat16 a, bfloat16 b) {
         return f2bf(bf2f(a) + bf2f(b));
    }

    //////////////////////////////////////////////////////////////////////////////
    bfloat16 bf_div(bfloat16 a, bfloat16 b) {
         return f2bf(bf2f(a) / bf2f(b));
    }

#endif
