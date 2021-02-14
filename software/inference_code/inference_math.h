// math functions for inference - mostly approximations

#ifndef _INFERENCE_MATH_H
    #define _INFERENCE_MATH_H

    #include "nios_alt_types.h"
    
    #define INFINITY 100000.0f // hopefully large enough

    //////////////////////////////////////////////////////////////////////////////
    float old_exp_fn(float x)  // quartic spline approximation
    {
        union int_float reinterpreter;
        alt_u32 m;

        reinterpreter.i = (alt_u32)(12102203.0f*x) + 127*(1 << 23);
        m = (reinterpreter.i >> 7) & 0xFFFF;
        reinterpreter.i += (((((((((((3537*m) >> 16)
            + 13668)*m) >> 18) + 15817)*m) >> 14) - 80470)*m) >> 11);
        return reinterpreter.f;
    }

    //////////////////////////////////////////////////////////////////////////////
    float natural_exponent(float x) {
      x = 1.0 + (x / 1024.0);
      x *= x; x *= x; x *= x; x *= x;
      x *= x; x *= x; x *= x; x *= x;
      x *= x; x *= x;
      return x;
    }

    //////////////////////////////////////////////////////////////////////////////
    float natural_log(float y) {
        alt_32 log2, yy;
        float divisor, x, result;

        log2=0;
        yy = (alt_u32)y;
        while (yy >>= 1)
            log2++;
        divisor = (float)(1 << log2);
        x = y / divisor;    // normalized value between [1.0, 2.0]

        result = -1.7417939 + (2.8212026 + (-1.4699568 + (0.44717955 - 0.056570851 * x) * x) * x) * x;
        result += ((float)log2) * 0.69314718; // ln(2) = 0.69314718

        return result;
    }

#endif
