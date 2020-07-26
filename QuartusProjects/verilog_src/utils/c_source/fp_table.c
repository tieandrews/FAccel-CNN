#include <stdlib.h>
#include <stdio.h>

void main(void) {
    float x;
    union floatcast {
        float f;
        //unsigned char s[sizeof(float)];
        unsigned long l;
    };

    union floatcast z;

    for (x=0.0; x<=63.0; x++) {
        z.f = (x * 4.0) / 256.0;
        if (((int)x % 8) == 0) {
            //printf("\n");
            //printf("@%x ", (int)x);
        }
        printf("6'h%x : lut_data = 16'h%x;\n", (int)x, (z.l >> 16) & 0xffff);
        //printf("%x ", (z.l >> 16) & 0xffff);
    }
}
