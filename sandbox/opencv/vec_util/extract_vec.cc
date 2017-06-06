/* -*- coding:utf-8; -*- */
/*
  【vec ファイルの分解】
  ・指定された vec ファイル内に格納されている、画像ファイルをすべて抽出します。
 */

#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <ctype.h>
#include <string.h>
//
#include <cv.h>
#include <highgui.h>

typedef struct CvVecFile
{
    FILE*  input;
    int    count;
    int    vecsize;
    int    last;
    short* vector;
} CvVecFile;

static bool isDigit(const char *p)
{
  bool	bResult = false;

  if (p){
    bResult = true;
    for (; *p; p++){
      if (!::isdigit(*p)){
	bResult = false;
	break;
      }
    } // for()
  }
  return bResult;
} // isDigit()

static void usage()
{
  static const char	*pcszMsg[] = {
    "Usage: extract_vec [options] <vec filename>\n",
    "\t--width=width\tdefault=24\n",
    "\t--height=height\tdefault=24\n",
    "\t--type=png|jpg\tdefault=png\n",
  };
  int	i = 0;

  for (i = 0; i < (int)(sizeof(pcszMsg) / sizeof(const char**)); i++){
    printf(pcszMsg[i]);
  } // for()
} // usage()

static int icvGetHaarTraininDataFromVecCallback( CvMat* img, void* userdata )
{
    uchar tmp = 0;
    int r = 0;
    int c = 0;

    assert( img->rows * img->cols == ((CvVecFile*) userdata)->vecsize );
    
    fread( &tmp, sizeof( tmp ), 1, ((CvVecFile*) userdata)->input );
    fread( ((CvVecFile*) userdata)->vector, sizeof( short ),
           ((CvVecFile*) userdata)->vecsize, ((CvVecFile*) userdata)->input );
    
    if( feof( ((CvVecFile*) userdata)->input ) || 
        (((CvVecFile*) userdata)->last)++ >= ((CvVecFile*) userdata)->count )
    {
        return 0;
    }
    
    for( r = 0; r < img->rows; r++ )
    {
        for( c = 0; c < img->cols; c++ )
        {
            CV_MAT_ELEM( *img, uchar, r, c ) = 
                (uchar) ( ((CvVecFile*) userdata)->vector[r * img->cols + c] );
        }
    }

    return 1;
}

static int extractVec(const char *pcszVecFile, const char *pcszType, int nWidth, int nHeight)
{
  int	nResult = 0;
  CvVecFile	vecFile;
  CvMat		*pclCvMat = NULL;
  char	szFileName[PATH_MAX];
  short	sTmp = 0;
  int	i = 0;

  memset(&vecFile, 0, sizeof(vecFile));
  vecFile.input = fopen(pcszVecFile, "rb"); // vec ファイルオープン(読み込み)
  if (vecFile.input == NULL){
    fprintf(stderr, "error:: vec file(%s) can not open.", pcszVecFile);
    nResult = -1;
  } else {
    fread(&vecFile.count, sizeof(vecFile.count), 1, vecFile.input);
    fread(&vecFile.vecsize, sizeof(vecFile.vecsize), 1, vecFile.input);
    fread(&sTmp, sizeof(sTmp), 1, vecFile.input);
    fread(&sTmp, sizeof(sTmp), 1, vecFile.input);
    if (!feof(vecFile.input)){
      vecFile.last = 0;
      if (vecFile.vecsize != (nWidth * nHeight)){ // 画像サイズの不一致
	fprintf(stderr, "error:: vec file sample size not match(%d*%d!=%d)\n", nWidth, nHeight, vecFile.vecsize);
	nResult = -2;
      } else {
	// printf("count=%d, vecsize=%d, size=%d\n", vecFile.count, vecFile.vecsize, sizeof(*vecFile.vector));
	vecFile.vector = (short*)cvAlloc(sizeof(*vecFile.vector) * vecFile.vecsize); // メモリ取得
	pclCvMat = cvCreateMat(nHeight, nWidth, CV_8UC1);
	for (i = 0; i < vecFile.count; i++){ // 登録されているすべての画像データ
	  icvGetHaarTraininDataFromVecCallback(pclCvMat, &vecFile); // vec ファイルから1画像読み込み
	  sprintf(szFileName, "img_%05d.%s", i, pcszType); // ファイル名を連番で生成
	  cvSaveImage(szFileName, pclCvMat);		   // 画像ファイルを出力
	} // for()
	cvReleaseMat(&pclCvMat); // メモリ解放
	pclCvMat = NULL;
	cvFree(&vecFile.vector); // メモリ解放
	vecFile.vector = NULL;
      }
    }
    fclose(vecFile.input);	// vec ファイルクローズ
    vecFile.input = NULL;
  }
  return nResult;
} // extractVec()

int main(int ac, char **av)
{
  int	nResult = 0;
  int	nWidth = 24;
  int	nHeight = 24;
  const char *pcszType = "png";
  bool	bError = false;
  int	c = 0;
  static struct	option long_options[] = {
    {"width", 1, NULL, 'w'},
    {"height", 1, NULL, 'h'},
    {"type", 1, NULL, 't'},
    //
    {NULL, 0, NULL, 0},
  };
  int	option_index = 0;
  const char	*pcszVecFile = NULL;

  optind = 0;
  for (; !bError;){
    c = ::getopt_long(ac, av, "w:h:t:", long_options, &option_index);
    if (c != -1){
      // printf("c=%d, [%s]\n", c, (optarg ? optarg : "NULL"));
      switch (c){
      case 'w':
	if (optarg && isDigit(optarg)){
	  nWidth = atoi(optarg);
	} else {
	  fprintf(stderr, "error:: width argument(%s).\n", (optarg ? optarg : "NULL"));
	  bError = true;
	}
	break;
      case 'h':
	if (optarg && isDigit(optarg)){
	  nHeight = atoi(optarg);
	} else {
	  fprintf(stderr, "error:: height argument(%s).\n", (optarg ? optarg : "NULL"));
	  bError = true;
	}
	break;
      case 't':
	if (optarg &&
	    (!strcmp(optarg, "png") ||
	     !strcmp(optarg, "jpg"))){
	  pcszType = optarg;
	} else {
	  fprintf(stderr, "error:: type argument(%s).\n", (optarg ? optarg : "NULL"));
	  bError = true;
	}
	break;
      default:
	break;
      } // switch()
    } else {
      break;
    }
  } // for()
  if (!bError){
    if ((optind + 1) == ac){
      pcszVecFile = av[optind];
      // printf("w=%d, h=%d, t=%s, vec[%s]\n", nWidth, nHeight, pcszType, pcszVecFile);
      nResult = extractVec(pcszVecFile, pcszType, nWidth, nHeight);
    } else {
      usage();
    }
  } else {
    usage();
  }
  return nResult;
} // main()
