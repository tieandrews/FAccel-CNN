#include <stdio.h>
// #include <windows.h>

#pragma pack(2) /*2 byte packing */

typedef struct
{
unsigned short int type;
unsigned int size;
unsigned short int reserved1,reserved2;
unsigned int offset;
}Header;

#pragma pack() /* Default packing */

typedef struct
{
   unsigned long size;
   unsigned long width;
   unsigned long height;
   unsigned short planes;
   unsigned short bitcount;
   unsigned long compression;
   unsigned long sizeimage;
   long xpelspermeter;
   long ypelspermeter;
   unsigned long colorsused;
   unsigned long colorsimportant;
}Infoheader;

typedef unsigned char BYTE;

typedef struct {
   BYTE red;
   BYTE green;
   BYTE blue;
} Single_pixel;


FILE *fp_rgb; //global file pointer to rgb image

void BMP24ToRGB565 ( BYTE *bmp_24 )
{
  
    BYTE *rgb_565 = new BYTE[2];
    
    BYTE Red24 = bmp_24[0];   // 8-bit red
    BYTE Green24 = bmp_24[1]; // 8-bit green
    BYTE Blue24 = bmp_24[2];  // 8-bit blue
    
    BYTE Red16   = Red24   >> 3;  // 5-bit red
    BYTE Green16 = Green24 >> 2;  // 6-bit green
    BYTE Blue16  = Blue24  >> 3;  // 5-bit blue
    
    printf("\n Red16: %x \n", Red16);
    printf(" Green16: %x \n", Green16);
    printf(" Blue16: %x \n", Blue16);
    
    unsigned short RGB2Bytes = Blue16 + (Green16<<5) + (Red16<<(5+6));
    printf(" RGB2Bytes: %d \n", RGB2Bytes);

    rgb_565[0] = LOBYTE(RGB2Bytes);
    rgb_565[1] = HIBYTE(RGB2Bytes);
    printf(" rgb_565[0]: %x \n", rgb_565[0]);
    printf(" rgb_565[1]: %x \n\n", rgb_565[1]);
    
    //fwrite(rgb_565,1, sizeof(rgb_565), fp_rgb);
    
    BYTE low = rgb_565[0];
    BYTE high = rgb_565[1];
    
    fwrite(&low, 1, sizeof(low), fp_rgb);
    fwrite(&high, 1, sizeof(high), fp_rgb); 
           
}



int main()
{
   Header headfirst;
   Infoheader headsecond;
   Single_pixel single_pixel;
   
   int byte_border;
   
   /* binary opening of the input image file (24bit bmp) */
   FILE *fin;
   fin = fopen("flower.bmp","rb+");
   if(fin==NULL) //file doesnt exist
   {
      printf("Error opening first file");
      exit(0);
      return 0;
   }
   
   /* binary opening of the output image file (rgb565) */
   fp_rgb = fopen("rgb565.bin", "wb");
   
   //from first header
   fread(&headfirst,sizeof(headfirst),1,fin);

   printf("type: %x\n",headfirst.type);
   printf("total size: %u\n",headfirst.size);
   printf("offset: %u\n",headfirst.offset);

   //from second header
   fread(&headsecond,sizeof(headsecond),1,fin);

   printf("width: %u\n",headsecond.width);
   printf("width: %u\n",headsecond.height);
   printf("bitcount(color depth): %u\n",headsecond.bitcount);
   printf("size image (image size): %u\n",headsecond.sizeimage);

   //size calculations
   byte_border = headsecond.sizeimage / 1024; //calculate how many bytes the image size is.
   printf("image size in bytes: %d\n", byte_border); 
   
   //BMP pixel array
   BYTE *bmp_24 = new BYTE[3];
   
   for(int i = 0; i< byte_border / 3; i++)  //should loop for byte_border/3, consequently reading all BMP pixels in the image
   {
   fread(&single_pixel,sizeof(single_pixel),1,fin);
   
   printf("red: %x\n",single_pixel.red);
   printf("green: %x\n",single_pixel.green);
   printf("blue: %x\n",single_pixel.blue);
   
   bmp_24[0] = single_pixel.red;
   bmp_24[1] = single_pixel.green;
   bmp_24[2] = single_pixel.blue;
   
   BMP24ToRGB565(bmp_24);
   
   }
   
   fclose(fin);
   fclose(fp_rgb);
   
   /* TEST PART ---> checking output rgb565 file */
   FILE *fp_test;
   fp_test = fopen("rgb565.bin","rb+");
   if(fp_test==NULL) //file doesnt exist
   {
      printf("Error opening first file");
      exit(0);
      return 0;
   }
   
    unsigned short RGB2Bytes;
    BYTE *rgb565_test = new BYTE[2];
    BYTE low;
    BYTE high;
      
   for(int i = 0; i< 20 /*(byte_border / 3) * 2 */; i++)  //should loop for byte_border/3 *2 , consequently reading all RGB pixels in the image
   {
   
   //fread(&RGB2Bytes,sizeof(RGB2Bytes),1,fp_test);
   //rgb565_test[0] = LOBYTE(RGB2Bytes);
   //rgb565_test[1] = HIBYTE(RGB2Bytes);
   //printf("\n RGB TEST - RGB2Bytes: %d\n", RGB2Bytes);
   //printf("RGB TEST - rgb565_test[0]: %x\n",rgb565_test[0]);
   //printf("RGB TEST - rgb565_test[1]: %x\n\n",rgb565_test[1]);
    
   fread(&low,sizeof(low),1,fp_test);
   fread(&high,sizeof(high),1,fp_test);

   printf("\nRGB TEST - low: %x\n", low);
   printf("RGB TEST - high: %x\n", high);
   
   
   }
   
   system("pause");

   return 0;

}
