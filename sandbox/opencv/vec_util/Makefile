# -*- coding:utf-8; -*-

# 分解
EXTRACT_VEC=extract_vec
# 構築
CREATE_VEC=create_vec
#
OPENCV_INC=/usr/include/opencv/
CXXFLAGS=-g -Wall -O3 -I $(OPENCV_INC)
LDFLAGS=-l cv -l highgui
#
all: $(EXTRACT_VEC) $(CREATE_VEC)

# 分解
$(EXTRACT_VEC):$(EXTRACT_VEC).o
$(EXTRACT_VEC)o:$(EXTRACT_VEC).cc

# 構築
$(CREATE_VEC):$(CREATE_VEC).o
$(CREATE_VEC).o:$(CREATE_VEC).cc


clean:
	@rm -rf *.o *~ $(EXTRACT_VEC) $(CREATE_VEC) *.png *.jpg output.vec TEST0 TEST1

test_e:$(EXTRACT_VEC)
	-@mkdir TEST0>/dev/null 2>&1
	(cd TEST0&&../$(EXTRACT_VEC) -w 44 -h 18 -t png ../test.vec)
	(cd TEST0&&../$(EXTRACT_VEC) -w 44 -h 18 -t jpg ../test.vec)

test_c:$(CREATE_VEC)
	-@mkdir TEST1>/dev/null 2>&1
	(cd TEST1&&../$(CREATE_VEC) -w 44 -h 18 -v output_p.vec ../TEST0/img_*.png)
	(cd TEST1&&../$(CREATE_VEC) -w 44 -h 18 -v output_j.vec ../TEST0/img_*.jpg)

#
ZIP_TARGET=vec_util_`date +%y%m%d`.zip
FILES=$(EXTRACT_VEC).cc $(CREATE_VEC).cc ReadMe.txt Makefile
zip:$(EXTRACT_VEC) $(CREATE_VEC)
	@rm -rf /tmp/vec_util*
	@mkdir /tmp/vec_util/
	@cp -p $(FILES) /tmp/vec_util/
	@(cd /tmp/ && zip $(ZIP_TARGET) vec_util/*)
	@mv /tmp/$(ZIP_TARGET) .
	@rm -rf /tmp/vec_util*
#
