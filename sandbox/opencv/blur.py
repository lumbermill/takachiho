import cv2
import common

img1 = common.imread('dog.jpg',0)
img2 = cv2.blur(img1,(5,5))

common.imshow('blur',img1,img2)

