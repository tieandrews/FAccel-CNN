// BMP helper functions

#include <stdio.h>
#include <stdlib.h>

typedef unsigned char alt_u8;
typedef unsigned short alt_u16;
typedef unsigned long alt_u32;
typedef signed long alt_32;

//////////////////////////////////////////////////////////////////////////////
alt_u32 read_bmp_word(alt_u8* ptr, alt_u8 lngth) {  // lsbyte first small endian?
	alt_u32 s, i, d;
	s = 0;
	d = 0;
	for (i=0; i<lngth; i++) {
		s = s + (alt_u32)(ptr[i] << d);
		d += 8;
	}
	return s;
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
alt_u16 get_bmp_565_pixel(alt_u8* src, alt_u32 image_width, alt_u32 image_height, alt_u32 x, alt_u16 y) {
	alt_u32 pixel, pixel_data_offset, image_bytes, delta;
    
    pixel_data_offset = get_bmp_image_offset(src);
    image_bytes = image_width * 3;
    delta = image_bytes & 0x3;  // align image on 4 byte boundary
    if (delta > 0)
        image_bytes = image_bytes + 4 - delta;
	pixel_data_offset = pixel_data_offset + ((image_height - y - 1) * image_bytes) + (x * 3);
	pixel = (alt_u32)(src[pixel_data_offset++] >> 3);
	pixel = pixel | (alt_u32)((src[pixel_data_offset++] & 0xfc) << 3);
	return (alt_u16)(pixel | (alt_u32)((src[pixel_data_offset] & 0xf8) << 8));
}

//////////////////////////////////////////////////////////////////////////////
void put_bmp_565_pixel(alt_u8* src, alt_u32 image_width, alt_u32 image_height, alt_u32 x, alt_u32 y, alt_u16 pixel) {
	alt_u32 pixel_data_offset, image_bytes, delta;
    
    pixel_data_offset = get_bmp_image_offset(src);
    image_bytes = image_width * 3;
    delta = image_bytes & 0x3;  // align image on 4 byte boundary
    if (delta > 0)
        image_bytes = image_bytes + 4 - delta;
	pixel_data_offset = pixel_data_offset + ((image_height - y - 1) * image_bytes) + (x * 3);
	src[pixel_data_offset++] = (alt_u8)((pixel & 0x1f) << 3);
	src[pixel_data_offset++] = (alt_u8)(((pixel >> 5) & 0x3f) << 2);
	src[pixel_data_offset] = (alt_u8)(((pixel >> 11) & 0x1f) << 3);
}

//////////////////////////////////////////////////////////////////////////////
// resize a bitmap to a 565 binary array
void resize_bmp(alt_u8* bmp_src, alt_u16* bin_dst, alt_u32 width, alt_u32 height, alt_u32 new_width, alt_u32 new_height) {
    alt_u16 cx, cy, pixel;
    alt_u16 x, y;
    alt_32 nearest;
    float scale_width, scale_height;

    scale_width =  (float)new_width / (float)width;
    scale_height = (float)new_height / (float)height;

    for (cy = 0; cy < new_height; cy++) {
        for (cx = 0; cx < new_width; cx++) {
            x = (alt_u16)((float)cx / scale_width);
            y = (alt_u16)((float)cy / scale_height);
            pixel = get_bmp_565_pixel(bmp_src, width, height, x, y);
            bin_dst[(new_width * cy) + cx] = pixel;
        }
    }
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
void main() {
    alt_32 x, y;
    alt_u32 fsize, pixel_data_offset, image_width, image_height, bpp;
    alt_u16 new_x, new_y, pixel;
    
    FILE *f;
    
    // set new resolution
    new_x = 64;
    new_y = 64;
    
    // open the file and read to memory
    f = fopen("flower.bmp", "rb");
    fseek(f, 0, SEEK_END);
    fsize = ftell(f);
    fseek(f, 0, SEEK_SET);  /* same as rewind(f); */
    alt_u8 *string = malloc(fsize + 1);
    fread(string, 1, fsize, f);
    fclose(f);
    string[fsize] = 0; // terminate the string

    // read the BMP header info
	pixel_data_offset = get_bmp_image_offset(string);
	image_width = get_bmp_width(string);
	image_height = get_bmp_height(string);
	bpp = get_bmp_bpp(string);

    printf("Create RGB565 image from BMP, input BMP detail:\n");
    printf("X resolution = %d\n", image_width);
    printf("Y resolution = %d\n", image_height);
    printf("         BPP = %d\n", bpp);

    if (bpp != 24) {
        printf("Image must be 24BPP\n");
        exit(1);
    }
    
    alt_u16* new_image = malloc(new_x * new_y * 2); // allocate new array for scaled image
    
    // modify BMP in memory
    resize_bmp(string, new_image, image_width, image_height, new_x, new_y);

    // delete any existing file then write the bmp to disk
    if (remove("out.bin") == 0) 
        printf("Deleted successfully\n"); 
    if ((f = fopen("out.bin", "wb")) == NULL)
    {
        printf("Unable to open file!\n");
        exit(1);
    }
    if (fwrite(new_image, (new_x * new_y), 1, f) != 1)
    {
        printf("Write error!\n");
        exit(1);
    }
    else
        printf("Write was successful.\n");
    fclose(f);
    free(string);   
}
