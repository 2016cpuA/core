#include <stdio.h>

int main(int argc, char **argv){
		FILE *fp;
		FILE *gp;
		char buf[14];
		int i;
		fp = fopen(argv[1], "r");
		gp = fopen("bin_2", "w");
		while(fscanf(fp, " %s\n", buf) != EOF){
			for(i=0;i<13;i++){
				switch(buf[i]){
					case '0':
						fprintf(gp, "0\n0\n0\n0\n");
						break;
					case '1':
						fprintf(gp, "0\n0\n0\n1\n");
						break;
					case '2':
						fprintf(gp, "0\n0\n1\n0\n");
						break;
					case '3':
						fprintf(gp, "0\n0\n1\n1\n");
						break;
					case '4':
						fprintf(gp, "0\n1\n0\n0\n");
						break;
					case '5':
						fprintf(gp, "0\n1\n0\n1\n");
						break;
					case '6':
						fprintf(gp, "0\n1\n1\n0\n");
						break;
					case '7':
						fprintf(gp, "0\n1\n1\n1\n");
						break;
					case '8':
						fprintf(gp, "1\n0\n0\n0\n");
						break;
					case '9':
						fprintf(gp, "1\n0\n0\n1\n");
						break;
					case 'a':
						fprintf(gp, "1\n0\n1\n0\n");
						break;
					case 'b':
						fprintf(gp, "1\n0\n1\n1\n");
						break;
					case 'c':
						fprintf(gp, "1\n1\n0\n0\n");
						break;
					case 'd':
						fprintf(gp, "1\n1\n0\n1\n");
						break;
					case 'e':
						fprintf(gp, "1\n1\n1\n0\n");
						break;
					case 'f':
						fprintf(gp, "1\n1\n1\n1\n");
						break;
				}
				if (i == 1) fprintf(gp, "1\n");
			}
		}
		fclose(fp);
		fclose(gp);
		return 0;
}
						
