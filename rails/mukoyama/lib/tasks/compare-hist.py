#! /usr/bin/python3 -u

# Returns the similarity of 2 images.

import cv2, sys

i1 = cv2.imread(sys.argv[1],0)
i2 = cv2.imread(sys.argv[2],0)

channels = [0]
histSize = [256]
mask = None
ranges = [0,256]
h1 = cv2.calcHist([i1], channels, mask, histSize, ranges)
h2 = cv2.calcHist([i2], channels, mask, histSize, ranges)

method = cv2.HISTCMP_CORREL
print(cv2.compareHist(h1, h2, method))
