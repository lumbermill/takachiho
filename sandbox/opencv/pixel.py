import cv2
import common

img1 = common.imread('dog.jpg')
img2 = img1.copy()
v = img2.item(10,20)
print v
for y in range(10,20):
    for x in range(20,40):
        img2.itemset((y,x),(x+y)*4)
v = img2.item(10,20)
print v
v = img2.item(19,39)
print v

common.imshow('pixel',img1,img2)




