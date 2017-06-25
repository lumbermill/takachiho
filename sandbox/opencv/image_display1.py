import cv2

img = cv2.imread('samples/dog.jpg',0)

cv2.imshow('Dog', img)
k = cv2.waitKey(0) # & 0xFF needed?
if k == 27: # ESC
  cv2.destroyAllWindows()
elif k == ord('s'): # s
  cv2.imwrite('gray.jpg',img)
  cv2.destroyAllWindows()
