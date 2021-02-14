// try and keep this as NIOSII compatible as possible

#include <stdlib.h>
#include <stdio.h>
#include "nios_alt_types.h"
#include "bfloat16.h"
#include "bmp.h"
#include "rgb565.h"
#include "inference.h"
#include "inference_math.h"

// not needed for NIOS - for PC based development
#include <time.h>

#define INPUT_SIZE  64
#define KERNEL      3
#define NUM_CLASSES 10


//////////////////////////////////////////////////////////////////////////////
void show_featuremap(bfloat16* map, alt_u16 layer, alt_u16 xres, alt_u16 yres, alt_u16 sx, alt_u16 sy, alt_u16 type) {
    alt_u16 x, y;
    
    for (y=0; y<sy; y++) {
        for (x=0; x<sx; x++) {
            if (type == 0)
                printf("%x ", map[(layer*xres*yres)+x+(y*xres)]);
            if (type == 1)
                printf("%f ", bf2f(map[(layer*xres*yres)+x+(y*xres)]));
            if (type == 2)
                printf("%d ", (alt_u16)(bf2f(map[(layer*xres*yres)+x+(y*xres)]) * 255.0));
        }
        printf("\n");
    }
}


//////////////////////////////////////////////////////////////////////////////
void main() {
    alt_u16 bmp_image_height, bmp_image_width;
    
    alt_u16 input_image[INPUT_SIZE * INPUT_SIZE]; // 565 RGB Image array
    
    bfloat16 input_featuremap[3*(INPUT_SIZE*INPUT_SIZE)]; // 3 feature maps R, G, B
    
    bfloat16 layer1_featuremap[16*(INPUT_SIZE*INPUT_SIZE)];  // 16 feature maps
    bfloat16 layer1_weights[16*3*(KERNEL*KERNEL)];                      // 16x 3x (3x3) kernel weights
    
    bfloat16 layer2_featuremap[16*((INPUT_SIZE/2)*(INPUT_SIZE/2))];     // 16 feature maps
    
    bfloat16 layer3_featuremap[32*((INPUT_SIZE/2)*(INPUT_SIZE/2))];     // 32 feature maps
    bfloat16 layer3_weights[32*16*(KERNEL*KERNEL)];                     // 32 feature maps
    
    bfloat16 layer4_featuremap[32*((INPUT_SIZE/4)*(INPUT_SIZE/4))];     // 32 feature maps
    
    bfloat16 layer5_featuremap[NUM_CLASSES*((INPUT_SIZE/4)*(INPUT_SIZE/4))]; // 10x 32x (3x3) kernel weights
    bfloat16 layer5_weights[NUM_CLASSES*32*(KERNEL*KERNEL)];            // 10x 32x (3x3) kernel weights
    bfloat16 layer6_average[NUM_CLASSES];
    bfloat16 layer7_result[NUM_CLASSES];
    
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
        start = clock();
        scale_bmp_to_565(bmp_image, input_image, INPUT_SIZE, INPUT_SIZE);
        rgb565_to_featuremap(input_image, input_featuremap, INPUT_SIZE, INPUT_SIZE);

        rgb565_to_text(input_image, INPUT_SIZE, INPUT_SIZE, 1);
        
        convolution(input_featuremap, layer1_featuremap, layer1_weights, 3, 16, INPUT_SIZE, INPUT_SIZE, 1, 3, 1);
        max_pooling(layer1_featuremap, layer2_featuremap, 2, 64, 64, 2);
        convolution(layer2_featuremap, layer3_featuremap, layer3_weights, 16, 32, (INPUT_SIZE/2), (INPUT_SIZE/2), 1, 3, 1);
        max_pooling(layer3_featuremap, layer4_featuremap, 2, 32, 32, 2);
        convolution(layer4_featuremap, layer5_featuremap, layer5_weights, 32, NUM_CLASSES, (INPUT_SIZE/4), (INPUT_SIZE/4), 1, 3, 1);
        global_average_pooling(layer5_featuremap, layer6_average, (INPUT_SIZE/4), (INPUT_SIZE/4), NUM_CLASSES);
        softmax(layer6_average, layer7_result, NUM_CLASSES);
        stop = clock();
        for (i=0; i<NUM_CLASSES; i++)
            printf("%f ", bf2f(layer7_result[i]));
        printf("\nprocessing time = %dms\n", stop - start);
    }
    
    // free malloc'd memory
    free(bmp_image);   
}
