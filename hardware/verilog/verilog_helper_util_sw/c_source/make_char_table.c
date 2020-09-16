#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <inttypes.h>
#include "chars.h"

void main (int argc, char *argv[] ) {
    int i, j, x;
    x = 0;
    for (i=0; i<129; i++) {
        printf("@%x ", x);
        for (j=0; j<8; j++) {
            printf("%02x ", font[i][j]);
            x++;
        }
        printf("\n");
    }
}
