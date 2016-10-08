#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUL '\0'

int main(int argc, char* argv[])
{
    if (argc <= 1) {
        return -1;
    }
    char * infName = argv[1];
    char * outfName = (char *)malloc(strlen(argv[1])+strlen(".data")+1);
    strcpy(outfName, infName);
    char * pPoint = strchr(outfName, '.');
    *pPoint = NUL;
    strcat(outfName, ".data");
    FILE *fp_in = fopen(infName, "rb");
    fseek(fp_in, 0, SEEK_END);
    long fsize = ftell(fp_in);
    rewind(fp_in);

    FILE *fp_out = fopen(outfName, "w");
    unsigned char c;
    int line_cnt = 0;
    while(fsize--) {
        c = fgetc(fp_in);
        fprintf(fp_out, "%02x", c);
        if (++line_cnt % 4 == 0) {
            fputc('\n', fp_out);
        }
    }
    fclose(fp_in);
    fclose(fp_out);
    return 0;
}


