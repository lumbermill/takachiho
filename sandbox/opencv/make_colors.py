import cv2
import numpy
import common

img1 = numpy.zeros((60,360,3),numpy.uint8)
img2 = img1
h,w,_ = img1.shape

for y in range(0,h):
    for x in range(0,w):
        img1.itemset((y,x,0),x/2)
        img1.itemset((y,x,1),255)
        img1.itemset((y,x,2),255)
img2 = cv2.cvtColor(img1,cv2.COLOR_HSV2BGR)

common.imshow('colors',img1,img2)
