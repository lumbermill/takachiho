import cv2

e1 = cv2.getTickCount()
img1 = cv2.imread('dog.jpg',0)
img2 = cv2.blur(img1,(5,5))
e2 = cv2.getTickCount()
time = (e2 - e1) / cv2.getTickFrequency()

print "Elapsed: %.3fsec" % (time)
