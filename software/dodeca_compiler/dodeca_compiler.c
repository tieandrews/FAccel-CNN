/* dodeca compiler */

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv []) {
    
    uint32_t i, ptr, lngth;
    uint8_t keyword[32];

    FILE *f_ptr;
    uint32_t fsize;
        
    f_ptr = fopen(argv[1], "rb");
    if (f_ptr) {
        fseek(f_ptr, 0, SEEK_END);
        fsize = ftell(f_ptr);
        fseek(f_ptr, 0, SEEK_SET);  // same as rewind(f_ptr);
        uint8_t* source_file = malloc(fsize);
        fread(source_file, 1, fsize, f_ptr);
        fclose(f_ptr);
        
        ptr = 0;
        while (ptr<fsize) {
            while ((ptr < fsize) && (source_file[ptr] < 0x21)) {
                ptr++;
            }
            lngth = 0;
            while ((ptr < fsize) && (lngth < 32) && (source_file[ptr] > 0x20) && (source_file[ptr] < 0x7f)) {
                keyword[lngth++] = source_file[ptr++];
            }
            keyword[lngth] = 0x0;
            if (lngth > 1) {
                printf("[%s]", keyword);
            }
        }
        
        free(source_file);
    }
    else {
        printf("No such file\n");
    }
}