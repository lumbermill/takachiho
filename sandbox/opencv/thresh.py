import cv2
import common

img1 = common.imread('dog.jpg',0)
ret,img2 = cv2.threshold(img1,127,255,cv2.THRESH_BINARY)

common.imshow('thresh',img1,img2)
