// RGB565 helper functions

#ifndef __RGB565_H
    #define __RGB565_H

    #include "nios_alt_types.h"

    //////////////////////////////////////////////////////////////////////////////
    void rgb565_to_text(alt_u16* src, alt_u16 xres, alt_u16 yres, alt_u16 step) {

        alt_u16 x, y, xx, yy;
        alt_u32 line, src_ptr, sum;
        alt_u8 char_grey[92] = {32,96,45,46,39,95,58,44,34,61,94,59,60,43,33,42,63,
                47,99,76,92,122,114,115,55,84,105,118,74,116,67,123,51,70,41,73,108,
                40,120,90,102,89,53,83,50,101,97,106,111,49,52,91,110,117,121,69,93,
                80,54,86,57,107,88,112,75,119,71,104,113,65,85,98,79,100,56,35,72,
                82,68,66,48,36,109,103,77,87,38,81,37,78,64};

        for (y=0; y<yres; y+=step) {
            line = (y * xres);
            for (x=0; x<xres; x+=step) {
                sum = 0;
                src_ptr = (x + line);
                for (yy=0; yy<step; yy++) {
                    for (xx=0; xx<step; xx++) {
                        sum += rgb_to_grey(src[src_ptr + (xx + (yy * xres))]);
                    }
                }
                sum = (sum / (step * step));
                sum = (sum * 92) / 255;		// scale grey count
                printf("%c", char_grey[sum]);
            }
            printf("\n");
        }
    }

    //////////////////////////////////////////////////////////////////////////////
    void rgb565_to_featuremap(alt_u16* rgb, bfloat16* dst, alt_u16 xres, alt_u16 yres) {
        alt_u16 x, y, z, pixel, bits;
        alt_u32 image_offset_y, image_offset_x, frame_offset;
        bfloat16 zero = f2bf(0.0);
        
        for (y=0; y<yres; y++) {
            for (x=0; x<xres; x++) {
                pixel = rgb[x + (y*xres)];
                for (z=0; z<3; z++) {
                    if (z==2) bits = (pixel&0x1f)<<3;
                    if (z==1) bits = (pixel&0x7e0)>>3;
                    if (z==0) bits = (pixel&0xf800)>>8;
                    dst[(z*(xres*yres))+x+(y*xres)] = f2bf((float)bits/255.0);
                }
            }
        }
        
    }

#endif