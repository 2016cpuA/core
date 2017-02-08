#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <memory.h>
#include <string.h>

/* for SLD tata stream */
typedef union {
    int i;
    float f;
} fi_union;

/* the binary image of the input SLD data */
#define MAX_N_WORDS 4096
fi_union sld_words[MAX_N_WORDS];
unsigned sld_n_words = 0;

/*-----------------------------------------------------------------------------
 * read a float in the SLD file and append it to the array sld_words.
 * fp : input SLD file stream
 * RETURN value : the float read from the file
 */
float read_float(FILE* fp)
{
    float f;

    if(sld_n_words >= MAX_N_WORDS){
        exit(1);
    }

    if(fscanf(fp, "%f", &f) != 1){
        exit(1);
    }

    return (sld_words[sld_n_words++].f = f);
}

/*-----------------------------------------------------------------------------
 * read an integer in the SLD file and append it to the array sld_words.
 * fp : input SLD file stream
 * RETURN value : the integer read from the file
 */
int read_int(FILE* fp)
{
    int i;
    if(sld_n_words >= MAX_N_WORDS){
        exit(1);
    }

    if(fscanf(fp, "%d", &i) != 1){
        exit(1);
    }

    return (sld_words[sld_n_words++].i = i);
}

void read_vec3(FILE* fp)
{
    read_float(fp);
    read_float(fp);
    read_float(fp);
}

void read_sld_env(FILE* fp)
{
    /* screen pos */
    read_vec3(fp);
    /* screen rotation */
    read_float(fp);  read_float(fp);
    /* n_lights : Actually, it should be an int value ! */
    read_float(fp);
    /* light rotation */
    read_float(fp);  read_float(fp);
    /* beam  */
    read_float(fp);
}

void read_objects(FILE* fp)
{

    while (read_int(fp) != -1) {  /* texture : -1 -> end */
        /* form */
        read_int(fp);
        /* refltype */
        read_int(fp);
        /* isrot_p*/
        int is_rot = read_int(fp);
        /* abc */
        read_vec3(fp);
        /* xyz */
        read_vec3(fp);
        /* is_invert */
        read_float(fp);
        /* refl_param */
        read_float(fp); read_float(fp);
        /* color */
        read_vec3(fp);
        /* rot */
        if(is_rot){
            read_vec3(fp);
        }
    }
}

void read_and_network(FILE* fp)
{
    while(read_int(fp) != -1){
        while(read_int(fp) != -1);
    }
}

void read_or_network(FILE* fp)
{
    while(read_int(fp) != -1){
        while(read_int(fp) != -1);
    }
}

void read_sld(FILE* fp)
{
    read_sld_env(fp);
    read_objects(fp);
    read_and_network(fp);
    read_or_network(fp);
}

void load_sld_file(const char* sld_file_name)
{
    FILE* fp = fopen(sld_file_name, "rb");
    read_sld(fp);
    fclose(fp);
}

void write_bin_file(const char* bin_file_name)
{
    FILE* fp = fopen(bin_file_name, "wb");
    fwrite((char *)sld_words, sizeof(sld_words[0]), sld_n_words, fp);
    fclose(fp);
}

int main(int argc, char* argv[])
{
    load_sld_file(argv[1]);
    write_bin_file(argv[2]);

    return 0;
}

