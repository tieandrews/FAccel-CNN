// BMP helper functions

#ifndef BMP_H
    #define BMP_H

    #include "nios_alt_types.h"
 
    //////////////////////////////////////////////////////////////////////////////
    // read BMP word 
    alt_u32 read_bmp_word(alt_u8* src, alt_u8 lngth) {
        alt_u32 i, sum, d;
        sum = 0;
        for (i=0; i<lngth; i++) {
            sum += (alt_u32)src[i] << d;
            d += 8;
        }
        return sum;
    }

    //////////////////////////////////////////////////////////////////////////////
    alt_u32 get_bmp_width(alt_u8* src) {
        return read_bmp_word(src + 18, 4);
    }

    //////////////////////////////////////////////////////////////////////////////
    alt_u32 get_bmp_height(alt_u8* src) {
        return read_bmp_word(src + 22, 4);
    }

    //////////////////////////////////////////////////////////////////////////////
    alt_u32 get_bmp_image_offset(alt_u8* src) {
        return read_bmp_word(src + 10, 4);
    }

    //////////////////////////////////////////////////////////////////////////////
    alt_u32 get_bmp_bpp(alt_u8* src) {
        return read_bmp_word(src + 28, 2);
    }

    //////////////////////////////////////////////////////////////////////////////
    // get bmp image pixel pointer , clamped to image size
    alt_u32 get_bmp_pixel_pointer(alt_u8* bmp_image, alt_u16 x, alt_u16 y) {
        alt_u32 pixel, pixel_data_offset, image_words, delta;
        alt_u32 image_width, image_height, xx, yy;
        
        pixel_data_offset = get_bmp_image_offset(bmp_image);
        image_width = get_bmp_width(bmp_image);
        image_height = get_bmp_height(bmp_image);
        image_words = image_width * 3;
        xx = (x<0) ? 0 : (x > image_width) ? image_width : x;
        yy = (y<0) ? 0 : (y > image_width) ? image_width : y;
        delta = image_words & 0x3;  // align image on 4 byte boundary
        if (delta > 0)
            image_words = image_words + 4 - delta;
        return pixel_data_offset + ((image_height - yy - 1) * image_words) + (xx * 3);
    }

    //////////////////////////////////////////////////////////////////////////////
    // return 24 bit RGB pixel value
    alt_u32 get_bmp_pixel(alt_u8* bmp_image, alt_u16 x, alt_u16 y) {
        alt_u32 pixel_pointer, pixel;
        
        pixel_pointer = get_bmp_pixel_pointer(bmp_image, x, y);
        pixel = bmp_image[pixel_pointer++];
        pixel = pixel | (bmp_image[pixel_pointer++] << 8);
        return pixel | (bmp_image[pixel_pointer] << 16);
    }

    //////////////////////////////////////////////////////////////////////////////
    void scale_bmp_to_565(alt_u8* bmp_image, bfloat16* dst, alt_u16 sx, alt_u16 sy) {
        alt_u16 i, j, k, m, w, h;
        alt_u16 rgb;
        alt_u32 a, b, c, d, x, y;
        float x_ratio, y_ratio, sum;
        float x_diff, y_diff, prod;
        alt_u32 offset, image_offset, quad[4];

        w = get_bmp_width(bmp_image);
        h = get_bmp_height(bmp_image);
        x_ratio = ((float)w - 1.0) / (float)sx;
        y_ratio = ((float)h - 1.0) / (float)sy;

        // write scaled pixels
        for (i=0;i<sy;i++) {
            for (j=0;j<sx;j++) {
                x = (alt_32)(x_ratio * (float)j) ;
                y = (alt_32)(y_ratio * (float)i) ;
                x_diff = (x_ratio * (float)j) - (float)x ;
                y_diff = (y_ratio * (float)i) - (float)y ;
                for (k=0; k<4; k++) {
                    quad[k] = get_bmp_pixel(bmp_image, x + (k & 1), y + (k & 2));
                }
                rgb = 0;
                for (k=0; k<3; k++) {
                    // Yb = Ab(1-w)(1-h) + Bb(w)(1-h) + Cb(h)(1-w) + Db(wh)
                    sum = 0.0;
                    for (m=0; m<4; m++) {
                        prod = ((m & 0x1) ? x_diff : (1.0-x_diff)) * ((m & 0x2) ? y_diff : (1.0-y_diff));
                        sum +=  (float)((quad[m]>>(k<<3))&0xff)*prod;
                    }
                    rgb = (rgb << ((k==1)?6:5)) | ((alt_u16)sum >> ((k==1)?2:3));
                }
                dst[j+(i*sx)] = rgb;
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////////
    alt_u16 rgb_to_grey(alt_u16 rgb565) {
        alt_u16 grey;

        grey = (alt_u16)((float)((rgb565 & 0xf800) >> 8) * 0.299);
        grey += (alt_u16)((float)((rgb565 & 0x07e0) >> 3) * 0.587);
        grey += (alt_u16)((float)((rgb565 & 0x001f) << 3) * 0.114);
        return grey;
    }

#endif
