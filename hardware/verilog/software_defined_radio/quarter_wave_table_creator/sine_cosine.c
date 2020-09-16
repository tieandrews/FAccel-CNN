#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <inttypes.h>

void main (int argc, char *argv[] ) {
	int64_t k, bit_size, scale, max_value, full_table;
	double phase, v;
	
	if (argc != 4) {
		printf("usage <table.hex> <outbits> <full tabledepth>\n");
	}
	else {
        bit_size = atoi(argv[2]);
        full_table = atoi(argv[3]);
        scale = (1 << bit_size) - 1;
        max_value = (1 << (bit_size - 1)) - 1;
        printf("%x\n", max_value);
		for (k=0; k<(full_table / 4); k++) {
			phase = 2.0 * M_PI * (double)k / (double)full_table;
			phase += (M_PI / (double)full_table);
			v = (int64_t)((double)max_value * (double)sin(phase));
            //printf("%llx", v);
			if ((k % 8) == 0)
				printf("\n@%04x ", k);
			//printf("%0*x ", (int)((bit_size + 3) / 4), (int)v & scale);
			printf("%0*x ",((bit_size + 3) / 4) , (int)v);
		}
        printf("\n");
	}
}
