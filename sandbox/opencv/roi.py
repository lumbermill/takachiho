import cv2
import common

img1 = common.imread('dog.jpg',0)
img2 = img1[100:180, 90:150]  
cv2.rectangle(img2,(0,0),(59,79),255,3)

common.imshow('roi',img1,img2)
