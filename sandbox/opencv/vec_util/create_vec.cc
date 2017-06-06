/* -*- coding:utf-8; -*- */
/*
  【vec ファイルの構築】
  ・新しく vec ファイルを生成し、指定された画像ファイルをすべて格納します。
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
    "Usage: create_vec [options] <image filenames ...>\n",
    "\t--width=width\tdefault=24\n",
    "\t--height=height\tdefault=24\n",
    "\t--vec=vecfilename\tdefault=output.vec\n",
  };
  int	i = 0;

  for (i = 0; i < (int)(sizeof(pcszMsg) / sizeof(const char**)); i++){
    printf(pcszMsg[i]);
  } // for()
} // usage()

static void icvWriteVecHeader( FILE* file, int count, int width, int height )
{
    int vecsize;
    short tmp;

    /* number of samples */
    fwrite( &count, sizeof( count ), 1, file );
    /* vector size */
    vecsize = width * height;
    fwrite( &vecsize, sizeof( vecsize ), 1, file );
    /* min/max values */
    tmp = 0;
    fwrite( &tmp, sizeof( tmp ), 1, file );
    fwrite( &tmp, sizeof( tmp ), 1, file );
}

static void icvWriteVecSample( FILE* file, CvArr* sample )
{
    CvMat* mat, stub;
    int r, c;
    short tmp;
    uchar chartmp;

    mat = cvGetMat( sample, &stub );
    chartmp = 0;
    fwrite( &chartmp, sizeof( chartmp ), 1, file );
    for( r = 0; r < mat->rows; r++ )
    {
        for( c = 0; c < mat->cols; c++ )
        {
            tmp = (short) (CV_MAT_ELEM( *mat, uchar, r, c ));
            fwrite( &tmp, sizeof( tmp ), 1, file );
        }
    }
}

static int createVec(char **av, int optind, int ac, const char *pcszVecFile, int nWidth, int nHeight)
{
  int	nResult = 0;
  int	i = 0;
  CvVecFile	vecFile;
  IplImage	*piplImage0 = NULL;
  IplImage	*piplImage1 = NULL;

  memset(&vecFile, 0, sizeof(vecFile));
  vecFile.input = fopen(pcszVecFile, "wb"); // vec ファイルオープン(書き込み)
  if (vecFile.input == NULL){
    fprintf(stderr, "error:: vec file(%s) can not open(1).", pcszVecFile);
    nResult = -1;
  } else {
    vecFile.count = ac - optind; // 格納画像数
    vecFile.vecsize = nWidth * nHeight; // 画像ピクセル数
    vecFile.last = 0;
    icvWriteVecHeader(vecFile.input, vecFile.count, nWidth, nHeight); // vec ファイルヘッダ部書き込み
    //
    for (i = optind; i < ac; i++){ // 指定されたすべての画像ファイル
      piplImage1 = cvCreateImage(cvSize(nWidth, nHeight), IPL_DEPTH_8U, 1); // テンポラリ画像生成
      if (piplImage1 == NULL){
	fprintf(stderr, "error:: can not create image.");
	nResult = -2;
	break;
      }
      piplImage0 = cvLoadImage(av[i], CV_LOAD_IMAGE_GRAYSCALE); // 画像ファイル読み込み
      if (piplImage0 == NULL){
	fprintf(stderr, "error:: can not open file(%s).", av[i]);
	nResult = -3;
	break;
      }
      cvResize(piplImage0, piplImage1, CV_INTER_LINEAR); // 共通サイズへ、念のためリサイズ
      icvWriteVecSample(vecFile.input, piplImage1);	 // vec ファイルへ追加
      //
      if (piplImage1){
	cvReleaseImage(&piplImage1); // メモリ解放
	piplImage1 = NULL;
      }
      if (piplImage0){
	cvReleaseImage(&piplImage0); // メモリ解放
	piplImage0 = NULL;
      }
    } // for()
    // 後始末
    if (piplImage0){
      cvReleaseImage(&piplImage0); // メモリ解放
      piplImage0 = NULL;
    }
    if (piplImage1){
      cvReleaseImage(&piplImage1); // メモリ解放
      piplImage1 = NULL;
    }
    fclose(vecFile.input);	// vec ファイルクローズ
    vecFile.input = NULL;
  }
  return nResult;
} // createVec()

int main(int ac, char **av)
{
  int	nResult = 0;
  int	nWidth = 24;
  int	nHeight = 24;
  bool	bError = false;
  int	c = 0;
  static struct	option long_options[] = {
    {"width", 1, NULL, 'w'},
    {"height", 1, NULL, 'h'},
    {"vec", 1, NULL, 'v'},
    //
    {NULL, 0, NULL, 0},
  };
  int	option_index = 0;
  const char	*pcszVecFile = "output.vec";

  optind = 0;
  for (; !bError;){
    c = ::getopt_long(ac, av, "w:h:v:", long_options, &option_index);
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
      case 'v':
	if (optarg){
	  pcszVecFile = optarg;
	} else {
	  fprintf(stderr, "error:: vec file name argument(%s).\n", (optarg ? optarg : "NULL"));
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
    if (optind < ac){
      // printf("w=%d, h=%d, v=[%s], img0=[%s]\n", nWidth, nHeight, pcszVecFile, av[optind]);
      nResult = createVec(av, optind, ac, pcszVecFile, nWidth, nHeight);
    } else {
      usage();
    }
  } else {
    usage();
  }
  return nResult;
} // main()
