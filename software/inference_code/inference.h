// inference functions

#ifndef INFERENCE_H
    #define INFERENCE_H
    
    #include "nios_alt_types.h"
    #include "inference_math.h"

    //////////////////////////////////////////////////////////////////////////////
    void conv_single(bfloat16* src, bfloat16* dst, bfloat16* wgt, alt_u16 xres, alt_u16 yres,
                        alt_u16 kernel, alt_u16 stride, alt_u16 pad, alt_u16 clear_flag) {
        alt_u16 x, y;
        alt_16 ks, kx, ky;
        bfloat16 zero, sum;
        
        zero = f2bf(0.0);
        ks = (kernel >> 1);
        for (y=0; y<yres; y++) {
            for (x=0; x<xres; x++) {
                if (clear_flag) {
                    sum = zero;
                }
                else {
                    sum = dst[x+(y*xres)];
                }
                for (ky=-ks; ky<(kernel-ks); ky++) {
                    for (kx=-ks; kx<(kernel-ks); kx++) {
                        if (((y+ky)>=0)&&((y+ky)<=yres)&&((x+kx)>=0)&&((x+kx)<=xres)) {
                            sum = bf_add(sum, bf_mult(dst[(x+kx)+((y+ky)*xres)], wgt[kx+ks,ky+ks]));
                        }
                    }
                }
                dst[x+(y*xres)] = sum;
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////////
    void convolution(bfloat16* src, bfloat16* dst, bfloat16* wgt, alt_u16 in_layers, alt_u16 out_layers,
                        alt_u16 xres, alt_u16 yres, alt_u16 pad, alt_u16 kernel, alt_u16 stride) {
        alt_u16 l1, l2;
        
        for (l2=0; l2<out_layers; l2++) {
            for (l1=0; l1<in_layers; l1++) {
                conv_single(&src[l1*(xres*yres)], &dst[l2*(xres*yres)], &wgt[l2*l1*(kernel*kernel)],
                    xres, yres, kernel, stride, pad, (l1==0));
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////////
    void max_pooling(bfloat16* src, bfloat16* dst, alt_u16 pool, alt_u16 xres, alt_u16 yres, 
                        alt_u16 stride) {
        alt_u16 x, y, px, py, xc, yc;
        float max, pixel;
        
        yc = 0;
        for (y=0; y<yres; y+=stride) {
            xc = 0;
            for (x=0; x<xres; x+=stride) {
                max = -INFINITY;
                for (py=0; py<pool; py++) {
                    for (px=0; px<pool; px++) {
                        if (((x+px)<=xres)&&((y+py)<=yres)) {
                            pixel = bf2f(src[x+(y*xres)]);
                           if (pixel > max) {
                               max = pixel;
                           }
                        }
                    }
                }
                dst[xc+(yc*xres)] = max;
                xc++;
            }
            yc++;
        }
    }

    //////////////////////////////////////////////////////////////////////////////
    bfloat16 global_average_pooling(bfloat16* src, bfloat16* dst, alt_u16 xres, alt_u16 yres, alt_u16 layers) {
        alt_u16 x, y, l;
        bfloat16 zero, sum;
        
        zero = f2bf(0.0);
        for (l=0; l<layers; l++) {
            sum = zero;
            for (y=0; y<yres; y++) {
                for (x=0; x<xres; x++) {
                    sum = bf_add(sum, src[x+(y*xres)]);
                }
            }
            dst[l] = bf_div(sum, (bfloat16)(xres*yres));
        }        
    }
    
    //////////////////////////////////////////////////////////////////////////////
    void softmax(bfloat16* src, bfloat16* dst, alt_u16 input_len) {
        alt_u16 i;
        float m, sum, offset;

        sum = 0.0;
        m = -INFINITY;
        for (i = 0; i < input_len; i++)
            if (bf2f(src[i]) > m)
                m = bf2f(src[i]);
        for (i = 0; i < input_len; i++)
            sum += natural_exponent(bf2f(src[i]) - m);
        offset = m + natural_log(sum);
        for (i = 0; i < input_len; i++)
            dst[i] = f2bf(natural_exponent(src[i] - offset));
    }

    //////////////////////////////////////////////////////////////////////////////
    void featuremap_to_text(alt_u16* src, alt_u16 xres, alt_u16 yres) {

        alt_u16 x, y, xx, yy, p;
        alt_u32 line, src_ptr, sum;
        float max, min, pixel, m, c;
        alt_u8 char_grey[92] = {32,96,45,46,39,95,58,44,34,61,94,59,60,43,33,42,63,
                47,99,76,92,122,114,115,55,84,105,118,74,116,67,123,51,70,41,73,108,
                40,120,90,102,89,53,83,50,101,97,106,111,49,52,91,110,117,121,69,93,
                80,54,86,57,107,88,112,75,119,71,104,113,65,85,98,79,100,56,35,72,
                82,68,66,48,36,109,103,77,87,38,81,37,78,64};

        max = -INFINITY;
        min = INFINITY;
        for (x=0; x<xres*yres; x++) {
            pixel = bf2f(src[x]);
            max = (pixel > max) ? pixel : max;
            min = (pixel < min) ? pixel : min;
        }
        m = 255.0 / (max - min);
        c = (255 * min) / (min - max);
        for (y=0; y<yres; y++) {
            for (x=0; x<xres; x++) {
                p = (alt_u16)((92.0 * m * bf2f(src[x+(y*xres)]) + c) / 255.0);
                printf("%c", char_grey[p]);
            }
            printf("\n");
        }
    }

#endif
