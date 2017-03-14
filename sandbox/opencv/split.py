import cv2
import common

img1 = common.imread('dog.jpg',1)
img2 = img1.copy()
img2[:,:,2] = 0 # Make all red pixels to zero.

# b,g,r = cv2.split(img1)
# img2 = cv2.merge((b,g,r)) # Same image
# img2 = b # Grayscale image using red pixels

common.imshow('split',img1,img2)

# See below for details:
# http://docs.opencv.org/3.0-beta/doc/py_tutorials/py_core/py_basic_ops/py_basic_ops.html#splitting-and-merging-image-channels
