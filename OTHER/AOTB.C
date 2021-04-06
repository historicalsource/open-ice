#include <stdio.h>

int main(int argc, char *argv[]);
int read_header(int a,FILE *f);
int getbyte(FILE *f);
int getword(FILE *f);
void putbyte(int ch,FILE *f);
void putword(int ch,FILE *f);
void read_pal(int a, FILE *f);
int count_pal();
int convert_to_15(int red, int green, int blue);
int convert_to_5(int colr);
void show_palcount();
void dump_pal();
void dump_word(int wd);
void check_pixel(int op, int np);
int merge_image();
int merge_3();
// int merge_part1();
int find_diff(int oldpix, int newpix);
int find_match(int oldpix, int newpix);
void make_all_pals(int nump);
void rgb_to_hsv(int rr, int gg, int bb, int *hh, int *ss, int *vv);
void append_vertically();
void append_horizontally();
void write_combined_header(FILE *f);
void write_combined_header2(FILE *f);
long count_r24();

FILE *f, *g, *h, *i, *j;
int version[2];
int width[2];
int height[2];
int palsize[2];
int hdpi[2];
int vdpi[2];
int gamma[2];
int pal[2][3][256];
char truecount[32768];
int r24count[256][256][4];
int palused;
long palcount[256];
long r24used;
int wordcount;
int to_24;
int real_24;
int num_num;
int num_num2;
int eqs, eqs2;
int ptra[5000];
int ptrb[5000];
int ptrc[5000];
int nchs;
int f1whr, f2whr;

int main(int argc, char *argv[]) {
	int ppal, help;
	int temp1;
	to_24 = 0;
	real_24 = 0;
	ppal = 0;
	f1whr = 0;
	f2whr = 0;
	num_num = 50;
	num_num2 = 50;
	eqs = 0;
	eqs2 = 0;
	for (temp1 = 1; temp1 < argc; temp1++) {
		if ((argv[temp1][0] == '-') || (argv[temp1][0] == '/'))
			switch(argv[temp1][1]) {
				case 'a':
					to_24 = 4;
					break;
				case 't':
					to_24 = 0;
					break;
				case 'r':
					real_24 = 1;
					break;
				case 'p':
					ppal = 1;
					break;
				case 'l':
					ppal = 2;
					break;
				case 'm':
					ppal = 3;
					break;
				case 'e':
					sscanf(argv[temp1+1], "%d",&num_num);
					eqs = temp1+1;
					num_num = num_num * 7;
					break;
				case 'f':
					sscanf(argv[temp1+1], "%d",&num_num2);
					eqs2 = temp1+1;
					num_num2 = num_num2 * 7;
					break;
				case 'g':
					sscanf(argv[temp1+1], "%d",&num_num);
					eqs = temp1+1;
					ppal = 4;
					break;
				case 'v':
					ppal = 5;
					break;
				case 'h':
					ppal = 6;
					break;
				default:
					printf ("unknown option %s\n", argv[temp1]);
					exit(1);
			}
		else {
			if ((eqs != temp1) && (eqs2 != temp1)) {
				if (f1whr == 0)
					f1whr = temp1;
				else
					if (f2whr == 0)
						f2whr = temp1;
			}
		}
	}
	if ((ppal < 3) && (f2whr != 0)) {
		printf("only one input file needed\n");
		return(1);
	}
	if ((ppal >= 3) && (f2whr == 0)) {
		printf("two input files needed for merge\n");
		return(1);
	}
	if (argc == 1) {
		printf("aotb - HSI raw file manipulation\n");
		printf(" usage aotb file1.raw [file2.raw] [options]\n");
		printf("  -t = truncate 24 bit color values to 15 bits (default)\n");
		printf("  -a = round 24 bit color values to 15 bits\n");
		printf("  -r = use 24 bit color values as 24 bits\n");
		printf("  -p = print palette using .asm format (paletted files only);\n");
		printf("  -l = print all palette counts and values (paletted files only)\n");
		printf("  -m = merge palettes to create new palette and images\n");
		printf("  -e num = set merge palette threshhold file 1 (default = 50)\n");
		printf("  -f num = set merge palette threshhold file 2 (default = 50)\n");
		printf("  -g num = make num intermediate palettes including those in file1, file2\n");
		printf("  -v = append two images vertically (24 bit raw images only)\n");
		printf("  -h = append two images horizontally (24 bit raw images only)\n");
		return(0);
	}
	if (f1whr == 0) {
		printf ("must specify a filename\n");
		return (1);
	}
	f = fopen(argv[f1whr],"rb");
	if (f == NULL) {
		printf ("%s not found\n",argv[f1whr]);
		return(1);
	}
	if (read_header(0,f)) {
		printf("%s is not an HSI raw file\n",argv[f1whr]);
		return(1);
	}
	if (f2whr != 0) {
		g = fopen(argv[f2whr],"rb");
		if (g == NULL) {
			printf ("%s not found\n",argv[f2whr]);
			return(1);
		}
		if (read_header(1,g)) {
			printf("%s is not an HSI raw file\n",argv[f2whr]);
			return(1);
		}
	}
	printf("file %s\n",argv[f1whr]);
	printf(" size = %dx%d\n",width[0],height[0]);
	if (palsize[0])
		printf(" palsize = %d\n",palsize[0]);
	else
		printf(" true color image\n");
	if (palsize[0])
		read_pal(0,f);
	if (f2whr != 0) {
		printf("file %s\n",argv[f2whr]);
		printf(" size = %dx%d\n",width[1],height[1]);
		if (palsize[1])
			printf(" palsize = %d\n",palsize[1]);
		else
			printf(" true color image\n");
		if (palsize[1])
			read_pal(1,g);
	}
	switch(ppal) {
		case 0:
			if (palsize[0]) {
				palused = count_pal();
				printf("  palette entries used = %d\n",palused);
				if (palcount[0])
					printf("   zero color used - palette = %d %d %d",pal[0][0][0],pal[0][1][0],pal[0][2][0]);
				else
					printf("   zero color unused - palette = %d %d %d",pal[0][0][0],pal[0][1][0],pal[0][2][0]);
				printf("  (%d %d %d)\n",(pal[0][0][0]+to_24)>>3,(pal[0][1][0]+to_24)>>3,(pal[0][2][0]+to_24)>>3);
			}
			else {
				if(real_24) {
					r24used = count_r24();
					printf("  colors used = %ld/16777216\n",r24used);
				}
				else {
					palused = count_true();
					printf("  colors used = %d/32768\n",palused);
				}
			}
			break;
		case 1:
			dump_pal();
			break;
		case 2:
			count_pal();
			show_palcount();
			break;
		case 3:
//			merge_part1();
//			fclose(f);
//			fclose(g);
//			f = fopen(argv[f1whr],"rb");
//			read_header(0,f);
//			g = fopen(argv[f2whr],"rb");
//			read_header(1,g);
//			read_pal(0,f);
//			read_pal(1,g);
			merge_image();
			break;
		case 4:
			make_all_pals(num_num);
			break;
		case 5:
			append_vertically();
			break;
		case 6:
			append_horizontally();
			break;
	}
	fclose (f);
	if (f2whr != 0)
		fclose (g);
	return(0);
}

int read_header(int a,FILE *f) {
	int reserved;
	if (getbyte(f) != 0x6d)
		return(1);
	if (getbyte(f) != 0x68)
		return(1);
	if (getbyte(f) != 0x77)
		return(1);
	if (getbyte(f) != 0x61)
		return(1);
	if (getbyte(f) != 0x6e)
		return(1);
	if (getbyte(f) != 0x68)
		return(1);
	version[a] = getword(f);
	width[a] = getword(f);
	height[a] = getword(f);
	palsize[a] = getword(f);
	hdpi[a] = getword(f);
	vdpi[a] = getword(f);
	gamma[a] = getword(f);
	for (reserved = 0; reserved < 12; reserved++)
		getbyte(f);
	return(0);
}

void write_header(FILE *f) {
	int reserved;
	putbyte(0x6d,f);
	putbyte(0x68,f);
	putbyte(0x77,f);
	putbyte(0x61,f);
	putbyte(0x6e,f);
	putbyte(0x68,f);
	putword(4,f);
	putword(width[0],f);
	putword(height[0],f);
	putword(nchs,f);
	putword(hdpi[0],f);
	putword(vdpi[0],f);
	putword(gamma[0],f);
	for (reserved = 0; reserved < 12; reserved++)
		putbyte(0,f);
}

void write_combined_header(FILE *f) {
	int reserved;
	putbyte(0x6d,f);
	putbyte(0x68,f);
	putbyte(0x77,f);
	putbyte(0x61,f);
	putbyte(0x6e,f);
	putbyte(0x68,f);
	putword(4,f);
	putword(width[0],f);
	putword(height[0]+height[1],f);
	putword(nchs,f);
	putword(hdpi[0],f);
	putword(vdpi[0],f);
	putword(gamma[0],f);
	for (reserved = 0; reserved < 12; reserved++)
		putbyte(0,f);
}

void write_combined_header2(FILE *f) {
	int reserved;
	putbyte(0x6d,f);
	putbyte(0x68,f);
	putbyte(0x77,f);
	putbyte(0x61,f);
	putbyte(0x6e,f);
	putbyte(0x68,f);
	putword(4,f);
	putword(width[0]+width[1],f);
	putword(height[0],f);
	putword(nchs,f);
	putword(hdpi[0],f);
	putword(vdpi[0],f);
	putword(gamma[0],f);
	for (reserved = 0; reserved < 12; reserved++)
		putbyte(0,f);
}

void read_pal(int a, FILE *f) {
	int temp1;
	for (temp1 = 0; temp1 < palsize[0]; temp1++) {
		pal[a][0][temp1] = getbyte(f);
		pal[a][1][temp1] = getbyte(f);
		pal[a][2][temp1] = getbyte(f);
	}
}

int count_pal() {
	int xx,yy,pu,ch;
	pu = 0;
	for (yy = 0; yy < 256; yy++)
		palcount[yy] = 0;
	for (yy = 0; yy < height[0]; yy++)
		for (xx = 0; xx < width[0]; xx++) {
			ch = getbyte(f);
			if (palcount[ch] == 0)
				pu++;
			palcount[ch]=palcount[ch]+1;
		}
	return(pu);
}

void dump_pal() {
	int temp;
	wordcount = 0;
	printf ("\t.word\t%d",palsize[0]);
	for (temp = 0; temp < palsize[0]; temp++)
		dump_word(convert_to_15(pal[0][0][temp],pal[0][1][temp],pal[0][2][temp]));
}

void append_vertically() {
	int yy, xx;
	if ((palsize[0] > 0) || (palsize[1] > 0))
		printf("both images must be 24 bit raw formats\n");
	else {
		if (width[0] != width[1])
			printf("both images must be same width\n");
		else {
			h = fopen("both.raw","wb");
			write_combined_header(h);
			for (yy = 0; yy < height[0]; yy++)
				for (xx = 0; xx < width[0]; xx++) {
					putword(getword(f),h);
					putbyte(getbyte(f),h);
				}
			for (yy = 0; yy < height[1]; yy++)
				for (xx = 0; xx < width[1]; xx++) {
					putword(getword(g),h);
					putbyte(getbyte(g),h);
				}
			close(h);
		}
	}
}

void append_horizontally() {
	int yy, xx;
	if ((palsize[0] > 0) || (palsize[1] > 0))
		printf("both images must be 24 bit raw formats\n");
	else {
		if (height[0] != height[1])
			printf("both images must be same height\n");
		else {
			h = fopen("both.raw","wb");
			write_combined_header2(h);
			for (yy = 0; yy < height[0]; yy++) {
				for (xx = 0; xx < width[0]; xx++) {
					putword(getword(f),h);
					putbyte(getbyte(f),h);
				}
				for (xx = 0; xx < width[1]; xx++) {
					putword(getword(g),h);
					putbyte(getbyte(g),h);
				}
			}
			close(h);
		}
	}
}

void make_all_pals(int nump) {
	int pass;
	int temp1;
	int rd,gr,bl;
	for (pass = 0; pass < nump; pass++) {
		printf("npal_%d\n\t.word\t%d",pass,palsize[0]);
		wordcount = 0;
		for (temp1 = 0; temp1 < palsize[0]; temp1++) {
			rd = (((nump - pass) * pal[0][0][temp1]) + (pass * pal[1][0][temp1])) / nump;
			gr = (((nump - pass) * pal[0][1][temp1]) + (pass * pal[1][1][temp1])) / nump;
			bl = (((nump - pass) * pal[0][2][temp1]) + (pass * pal[1][2][temp1])) / nump;
			dump_word(convert_to_15(rd,gr,bl));
		}
		printf("\n");
	}
}

int merge_image() {
	int xx,yy;
	int px,qx;
	nchs = 0;
	if ((palsize[0] == 0) || (palsize[1] == 0)) {
		printf("both images must be paletted\n");
		return(0);
	}
	for (xx = 0; xx < 2000; xx++) {
		ptra[xx] = 0;
		ptrb[xx] = 0;
	}
	if ((height[0] == height[1]) && (width[0] == width[1])) {
		h = fopen("image.bin","wb");
		for (yy = 0; yy < height[0]; yy++) {
			for (xx = 0; xx < width[0]; xx++) {
				px = getbyte(f);
				qx = getbyte(g);
				check_pixel(px,qx);
			}

			printf("\r%d  %d",yy,nchs);
			flushall();
		}
		close(h);
		if (nchs <= 256) {
			i = fopen("mpal1.bin","wb");
			j = fopen("mpal2.bin","wb");
			write_header(i);
			write_header(j);
			for (xx = 0; xx < nchs; xx++) {
				putbyte(pal[0][0][ptra[xx]],i);
				putbyte(pal[0][1][ptra[xx]],i);
				putbyte(pal[0][2][ptra[xx]],i);
				putbyte(pal[1][0][ptrb[xx]],j);
				putbyte(pal[1][1][ptrb[xx]],j);
				putbyte(pal[1][2][ptrb[xx]],j);
			}
			close(i);
			close(j);
			printf("\nnew palette size is %d\n",nchs);
			printf("files 'mpal1.bin' 'mpal2.bin' and 'image.bin' created\n");
			return(0);
		}
		else
			printf("\npalette size %d is too big\n",nchs);
			return(1);
	}
	else
		printf("images must be same size\n");
			return(1);
}

void check_pixel(int op, int np) {
	int temp;
	int bail;
	int dif;
	int temp2;
	int temp3;
	temp = find_match(op, np);
	if (temp >= 0)
		putbyte(temp,h);
	else {
		if (((pal[0][0][op] == pal[1][0][np]) && (pal[0][1][op] == pal[1][1][np])) && (pal[0][2][op] == pal[1][2][np])) {
//		if (op == np) {
			ptra[nchs] = op;
			ptrb[nchs] = np;
			putbyte(nchs,h);
			nchs++;
		}
		else {
			bail = -1;
			dif = 3000;
			for (temp = 0; temp < nchs; temp++) {
				temp2 = find_diff(op, ptra[temp]);
				temp3 = find_diff(np, ptrb[temp]);
				if ((temp2 < num_num) && (temp3 < num_num2))
					if ((temp2 + temp3) < dif) {
						dif = temp2+temp3;
						bail = temp;
					}
			}
			if (bail >= 0)
				putbyte(bail,h);
			else {
				ptra[nchs] = op;
				ptrb[nchs] = np;
				putbyte(nchs,h);
				nchs++;
			}
		}
	}
}

int find_diff(int oldpix, int newpix) {
	int rd, gd, bd;
	int tot;
	if (nchs != 0) {
		rd = abs(pal[0][0][oldpix] - pal[1][0][newpix]);
		gd = abs(pal[0][1][oldpix] - pal[1][1][newpix]);
		bd = abs(pal[0][2][oldpix] - pal[1][2][newpix]);
		tot = (rd<<1) + (gd<<2) + bd;
	}
	else
		tot = 2000;
	return(tot);
}



//	int tot;
//	int hh1,ss1,vv1;
//	int hh2,ss2,vv2;
//	if (nchs != 0) {
//		rgb_to_hsv(pal[0][0][oldpix],pal[0][1][oldpix],pal[0][2][oldpix],&hh1,&ss1,&vv1);
//		rgb_to_hsv(pal[1][0][newpix],pal[1][1][newpix],pal[1][2][newpix],&hh2,&ss2,&vv2);
//		tot = abs(hh1 - hh2) + abs(ss1 - ss2) + abs(vv1 - vv2);
//	}
//	else
//		tot = 2000;
//	return(tot);
//}

void rgb_to_hsv(int rr, int gg, int bb, int *hh, int *ss, int *vv) {
	int min, max, delta;
	max = rr;
	if (gg > max)
		max = gg;
	if (bb > max)
		max = bb;
	*vv = max;
	min = rr;
	if (gg < min)
		min = gg;
	if (bb < min)
		min = bb;
	delta = max - min;
	if (max != 0)
		*ss = ((delta) * 255) / max;
	else
		*ss = 0;
	if (*ss == 0)
		*hh = 0;
	else {
		if (rr == max)
			*hh = ((gg - bb) * 255) / delta;
		else
			if (gg == max)
				*hh = 510 + (((bb - rr) * 255) / delta);
			else
				*hh = 1020 + (((rr - gg) * 255) / delta);
	}
	if (*hh < 0)
		*hh+=1530;
	*hh = *hh / 6;
}


//	float min,max;
//	float hhh, sss, vvv;
//	float delta;
//	float rrr, ggg, bbb;
//	rrr = (float)rr / 255.0;
//	ggg = (float)gg / 255.0;
//	bbb = (float)bb / 255.0;
//	max = rrr;
//	if (ggg > max)
//		max = ggg;
//	if (bbb > max)
//		max = bbb;
//	vvv = max;
//	min = rrr;
//	if (ggg < min)
//		min = ggg;
//	if (bbb < min)
//		min = bbb;
//	if (max != 0)
//		sss = (max - min) / max;
//	else
//		sss = 0;
//	if (sss == 0)
//		hhh = 0;
//	else {
//		delta = max - min;
//		if (rrr == max)
//			hhh = (ggg - bbb) / delta;
//		else
//			if (ggg == max)
//				hhh = 2 + (bbb - rrr) / delta;
//			else
//				hhh = 4 + (rrr - ggg) / delta;
//	}
//	hhh = hhh * 60;
//	if (hhh < 0)
//		hhh += 360;
//	*hh = (int)(hhh * 255.0 / 360.0);
//	*ss = (int)(sss * 255.0);
//	*vv = (int)(vvv * 255.0);
//}
//

int find_match(int oldpix, int newpix) {
	int found;
	int temp;
	found = -1;
	if (nchs != 0)
		for (temp = 0; ((temp < nchs) && (found < 0)) ;temp++)
			if (((ptra[temp] == oldpix) && (ptrb[temp] == newpix)))
				found = temp;
	return(found);
}

void show_palcount() {
	int temp1;
	for (temp1 = 0; temp1 < palsize[0]; temp1++) {
		printf("pal %d\t%ld\t0%02xh  0%02xh  0%02xh\t",temp1,palcount[temp1],pal[0][0][temp1],pal[0][1][temp1],pal[0][2][temp1]);
		printf("   (0%02xh  0%02xh  0%02xh)\n",convert_to_5(pal[0][0][temp1]),convert_to_5(pal[0][1][temp1]),convert_to_5(pal[0][2][temp1]));
	}
}

int count_true() {
	int xx,yy;
	int rr,gg,bb;
	int tc;
	int cn;
	cn = 0;
	for (yy = 0; yy < 32767; yy++)
		truecount[yy] = 0;
	for (yy = 0; yy < height[0]; yy++)
		for (xx = 0; xx < width[0]; xx++) {
			rr = getbyte(f);
			gg = getbyte(f);
			bb = getbyte(f);
			tc = convert_to_15(rr,gg,bb);
			if (truecount[tc] ==0) {
				cn++;
				truecount[tc] = 1;
			}
		}
	return(cn);
}

long count_r24() {
	long tlong1;
	int xx,yy;
	int rr,gg,bb;
	int bba;
	int bbm;
	long cn;
	int ex;
	cn = 0;
	for(rr = 0; rr < 256; rr++)
		for(gg = 0; gg < 256; gg++)
			for(bb = 0; bb < 4; bb++)
				r24count[rr][gg][bb] = 0;
	for (yy = 0; yy < height[0]; yy++)
		for (xx = 0; xx < width[0]; xx++) {
			rr = getbyte(f);
			gg = getbyte(f);
			bb = getbyte(f);
			bba = bb / 16;
			bbm = bb % 16;
			ex = 1 << bbm;
			if (!(r24count[rr][gg][bba] & ex)) {
				r24count[rr][gg][bba] = (r24count[rr][gg][bba] | ex);
				cn++;
			}
		}
	return(cn);
}

int convert_to_15(int red, int green, int blue) {
	int rd,gr,bl;
	switch (to_24) {
		case 0:
			return ((((red>>3)<<5)|(green>>3))<<5)|(blue>>3);
			break;
		default:
			rd = (red+to_24)>>3;
			gr = (green+to_24)>>3;
			bl = (blue+to_24)>>3;
			if (rd > 31)
				rd = 31;
			if (gr > 31)
				gr = 31;
			if (bl > 31)
				bl = 31;
			return ((((rd<<5)|gr)<<5)|bl);
			break;
	}
}

int convert_to_5(int colr) {
	int clr;
	switch (to_24) {
		case 0:
			return colr>>3;
			break;
		default:
			clr = (colr+to_24)>>3;
			if (clr > 31)
				clr = 31;
			return (clr);
			break;
	}
}

int getbyte(FILE *f) {
	return(getc(f));
}

int getword(FILE *f) {
	int temp;
	temp = getc(f);
	return (temp<<8|getc(f));
}

void putbyte(int ch, FILE *f) {
	putc (ch,f);
}

void putword(int ch, FILE *f) {
	putc (ch>>8,f);
	putc (ch & 0xff,f);
}

void dump_word(int wd) {
	if ((wordcount % 8) == 0)
		printf ("\n\t.word\t0%04xh",wd);
	else printf (",0%04xh",wd);
	wordcount++;
}

