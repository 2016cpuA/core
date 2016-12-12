#include <stdio.h>

int main(int argc, char **argv){
	FILE *fp;
	FILE *gp;
	char buf[200];
	int i,j=0;

	fp = fopen(argv[1], "r");
	gp = fopen(argv[2], "w");
	while(fscanf(fp, "%s\n", buf) != EOF){
		printf("%s", buf);
		if(buf[2]!='\0'){
			if(i == 0){
				fprintf(gp, "inst_mem[%d] <= 32'h%s", j, buf);
				i++;
			}else if(1<=i && i<=3){
				fprintf(gp, "%s", buf);
				i++;
			}else{
				fprintf(gp, "\n");
				i = 0;
				j++;
			}
		}
	}
	fclose(fp);
	fclose(gp);
	return 0;
}

