import cv2
import common
import numpy

img1 = common.imread('shapes.jpg',0)
ret,img1cp = cv2.threshold(img1,127,255,cv2.THRESH_BINARY)
contours, hierarchy = cv2.findContours(img1cp,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
img2 = numpy.zeros(img1.shape,numpy.uint8)
cv2.drawContours(img2, contours, -1, 255, 1)
print "number of contours = %d" % (len(contours))
for i in range(0,len(contours)):
    c = contours[i]
    f = cv2.FONT_HERSHEY_SIMPLEX
    a = cv2.contourArea(c)
    l = cv2.arcLength(c,True)
    m = "%d" % (i)
    print "%d: len=%d, arcLen=%d, area=%d" % (i,len(c),l,a)
    p = tuple(c[0][0])
    cv2.putText(img2,m,p,f,0.4,(255),1,cv2.CV_AA)

common.imshow('contours',img1,img2)

# See below for more details:
# http://docs.opencv.org/3.0-beta/doc/py_tutorials/py_imgproc/py_contours/py_contour_features/py_contour_features.html#contour-features
