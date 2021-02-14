// try and keep this as NIOSII compatible as possible

#include <stdlib.h>
#include <stdio.h>
//#include <math.h>

// create some NIOS alt_ types
typedef char alt_8;
typedef unsigned char alt_u8;
typedef unsigned short alt_u16;
typedef short alt_16;
typedef unsigned long alt_u32;
typedef signed long alt_32;

#include <time.h>

//////////////////////////////////////////////////////////////////////////////
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
bfloat16 bf_mult(bfloat16 a, bfloat16 b) {
     return f2bf(bf2f(a) * bf2f(b));
}

//////////////////////////////////////////////////////////////////////////////
bfloat16 bf_add(bfloat16 a, bfloat16 b) {
     return f2bf(bf2f(a) + bf2f(b));
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
void scale_bmp_to_featuremap(alt_u8* bmp_image, bfloat16* dst, alt_u16 sx, alt_u16 sy, alt_u16 pad) {
    alt_u16 i, j, k, m, w, h, cx, cy;
    alt_u16 rgb, pixel;
    alt_u32 a, b, c, d, x, y;
    float x_ratio, y_ratio, sum;
    float x_diff, y_diff, prod;
    alt_u32 offset, image_offset, quad[4];

    w = get_bmp_width(bmp_image);
    h = get_bmp_height(bmp_image);
    x_ratio = ((float)w - 1.0) / (float)sx;
    y_ratio = ((float)h - 1.0) / (float)sy;
    
    // clear padded pixels around destination featuremap
    bfloat16 zero = f2bf(0.0);
    image_offset = (sy+pad) * (sx+(pad<<1));
    for (k=0; k<3; k++) {
        offset = k*((sx+(pad<<1))*(sy+(pad<<1)));
        for (i=0; i<pad; i++) {
            for (j=0; j<sx+(pad<<1); j++) {
                dst[offset] = zero;
                dst[offset + image_offset] = zero;
                offset++;
            }
        }
        for (i=0; i<sy; i++) {
            for (j=0; j<pad; j++) {
                dst[offset+j] = zero;
                dst[offset+(sx+pad)+j] = zero;
            }
            offset += sx+(pad<<1);
        }
    }

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
                offset = k*((sx+(pad<<1))*(sy+(pad<<1)));
                dst[offset+(j+pad)+((sx+(pad<<1))*(i+pad))] = f2bf(sum/255.0);
            }
        }
    }
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
void rgb565_to_featuremap(alt_u16* rgb, bfloat16* dst, alt_u16 xres, alt_u16 yres, alt_u16 pad) {
    alt_u16 x, y, z, pixel, wx, wy, bits;
    alt_u32 image_offset_y, image_offset_x, frame_offset;
    bfloat16 zero = f2bf(0.0);
    
    // pad border
    wx = xres + (pad << 1);
    wy = yres + (pad << 1);
    frame_offset = wx * wy;
    image_offset_y = wx * (yres + pad);
    image_offset_x = (xres + pad);
    for (y=0; y<wy; y++) {
        for (x=0; x<wx; x++) {
            pixel = 0;
            if ((y>=pad)&&(y<(yres+pad))&&(x>=pad)&&(x<(xres+pad))) {
                pixel = rgb[x-pad + ((y-pad)*xres)];
            }
            for (z=0; z<3; z++) {
                if (z==2) bits = (pixel&0x1f)<<3;
                if (z==1) bits = (pixel&0x7e0)>>3;
                if (z==0) bits = (pixel&0xf800)>>8;
                dst[(z*frame_offset)+x+(y*wx)] = f2bf((float)bits/255.0);
            }
        }
    }
    
}

//////////////////////////////////////////////////////////////////////////////
void show_featuremap(bfloat16* map, alt_u16 xres, alt_u16 yres, alt_u16 sx, alt_u16 sy) {
    alt_u16 x, y;
    
    for (y=0; y<sy; y++) {
        for (x=0; x<sx; x++) {
            printf("%x ", map[x+(y*xres)]);
        }
        printf("\n");
    }
}

//////////////////////////////////////////////////////////////////////////////
void conv_single(bfloat16* src, bfloat16* dst, bfloat16* wgt, alt_u16 res, alt_u16 kernel,
                    alt_u16 stride, alt_u16 clear_flag) {
    alt_16 x, y, kx, ky, ks, ptr;
    bfloat16 sum, product;
    
    ks = (kernel >> 1);
    for (y=ks; y<res-(kernel-ks); y+=stride) {
        for (x=ks; x<res-(kernel-ks); x+=stride) {
            if (clear_flag)
                sum = f2bf(0.0);
            else
                sum = dst[x+(y*res)];
            ptr = 0;
            for (ky=-ks; ky<(kernel-ks); ky++) {
                for (kx=-ks; kx<(kernel-ks); kx++) {
                    product = bf_mult(src[(x+kx)+((y+ky)*res)], wgt[ptr++]);
                    sum = bf_add(sum, product);
                }
            }
            dst[x+(y*res)] = sum;
        }
    }
}

//////////////////////////////////////////////////////////////////////////////
void convolution(bfloat16* src, bfloat16* dst, bfloat16* wgt, alt_u16 in_layers, alt_u16 out_layers,
                    alt_u16 res, alt_u16 pad, alt_u16 kernel, alt_u16 stride) {
    
    alt_u16 l1, l2, w;
    
    w = res+(pad << 1);
    for (l2=0; l2<out_layers; l2++) {
        for (l1=0; l1<in_layers; l1++) {
            conv_single(&src[l1*w*w], &dst[l2*w*w], &wgt[l2*l1*kernel*kernel], w, kernel, stride, (l1==0));
        }
    }
}

//////////////////////////////////////////////////////////////////////////////
void max_pooling(alt_u16* src, alt_u16* dst, alt_u16 wgt, alt_u16 res, alt_u16 pad, alt_u16 stride) {
	alt_16 x, y, kx, ky;
	alt_u32 dst_ptr;
	float src_pix;
	bfloat16 max;

	dst_ptr = 0;
	for (y=pad; y<(res + pad); y=y+stride) {
		for (x=pad; x<(res + pad); x=x+stride) {
			max = f2bf(-10000.0); // negative enough?
			for (ky=0; ky<wgt; ky++) {
				for (kx=0; kx<wgt; kx++) {
                    src_pix = bf2f(src[(x+kx)+(res*(y+ky))]);
					if (src_pix > max) {
						max = f2bf(src_pix);
                    }
				}
			}
            dst[dst_ptr++] = max;
		}
	}
}

//////////////////////////////////////////////////////////////////////////////
bfloat16 global_average_pooling(alt_u16* src, alt_u16 layer, alt_u16 res) {
	alt_u32 x;
	bfloat16 sum;

	sum = f2bf(0.0);
	for (x=0; x<(res*res); x++) {
		sum = bf_add(sum, src[layer*(res*res)+x]);
	}
	return f2bf(bf2f(sum) / (float)(res * res));
}

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

//////////////////////////////////////////////////////////////////////////////
void softmax(alt_u16* src, alt_u16 input_len) {
	alt_u16 i;
	float m, sum, offset;

	sum = 0.0;
	m = -100000.0;
	for (i = 0; i < input_len; i++)
		if (bf2f(src[i]) > m)
			m = bf2f(src[i]);
	for (i = 0; i < input_len; i++)
		sum += natural_exponent(bf2f(src[i]) - m);
	offset = m + natural_log(sum);
	for (i = 0; i < input_len; i++)
		src[i] = f2bf(natural_exponent(src[i] - offset));
}

//////////////////////////////////////////////////////////////////////////////
void main() {
    alt_u16 bmp_image_height, bmp_image_width;
    
    alt_u16 num_classes = 10;   // CIFAR 10
    alt_u16 input_image[64*64]; // 565 RGB Image array
    bfloat16 input_featuremap[3*(66*66)]; // 3 feature maps
    bfloat16 layer1_featuremap[16*(66*66)];  // 16 feature maps
    bfloat16 layer1_kernel_weights[16*3*(3*3)]; // 16x 3x (3x3) kernel weights
    bfloat16 layer2_featuremap[32*(66*66)];  // 32 feature maps
    bfloat16 layer2_kernel_weights[32*16*(3*3)]; // 32x 16x (3x3) kernel weights
    bfloat16 layer3_featuremap[10*(66*66)];  // 32 feature maps
    bfloat16 layer3_kernel_weights[10*32*(3*3)]; // 10x 32x (3x3) kernel weights
    bfloat16 layer4_average[10];
    bfloat16 layer5_result[10];
    
    alt_u16 x, y, i;
    alt_u32 start, stop;

    // open the file and read to memory - this is not available in NIOS
    // we would have this image as an array in memory or captured from camera
    FILE *f_ptr;
    alt_u32 fsize;
    
    f_ptr = fopen("flower.bmp", "rb");
    fseek(f_ptr, 0, SEEK_END);
    fsize = ftell(f_ptr);
    fseek(f_ptr, 0, SEEK_SET);  // same as rewind(f_ptr);
    alt_u8* bmp_image = malloc(fsize);
    fread(bmp_image, 1, fsize, f_ptr);
    fclose(f_ptr);
    
    bmp_image_height = get_bmp_height(bmp_image);
    bmp_image_width = get_bmp_width(bmp_image);
    
    printf("BMP Image Details:\n");
    printf("Resolution = (%d,%d)\n", bmp_image_width, bmp_image_height);
    if (get_bmp_bpp(bmp_image) != 24) {
        printf("Image is not 24bpp.\n");
    }
    else {
        // create 3 of 64 by 64 padded bfloat16 image maps for RGB normalised to 0.0->1.0 from 0x0->0xff
        scale_bmp_to_565(bmp_image, input_image, 64, 64);
        rgb565_to_featuremap(input_image, input_featuremap, 64, 64, 1);
        // 16 output features, 3 input features, resolution 64x64, padding 1, 3x3 kernel, stride 1
        start = clock();
        convolution(input_featuremap, layer1_featuremap, layer1_kernel_weights, 3, 16, 64, 1, 3, 1);
        convolution(layer1_featuremap, layer2_featuremap, layer2_kernel_weights, 16, 32, 64, 1, 3, 1);
        convolution(layer2_featuremap, layer3_featuremap, layer3_kernel_weights, 32, 10, 64, 1, 3, 1);
        for (i=0; i<num_classes; i++) {
            layer4_average[i] = global_average_pooling(layer3_featuremap, i, 64);
        }
        softmax(layer4_average, 10);
        stop = clock();
        printf("%d ms\n", stop-start);
        for (i=0; i<num_classes; i++) {
            printf("%f ", bf2f(layer4_average[i]));
        }
        printf("\n");
    }
    // free malloc'd memory
    free(bmp_image);   
}
