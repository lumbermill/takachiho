import numpy
import cv2

SRCDIR = "samples"
DSTDIR = "results"

# Read an image from file.
# 1: IMREAD_COLOR, 0: IMREAD_GRAYSCALE, -1: IMREAD_UNCHANGED
def imread(name,flag=0):
    return cv2.imread(SRCDIR+"/"+name,flag)

# Print properties of the image.
def print_props(prefix,img):
    if img is None: return
    elif len(img.shape) == 2:
        # grayscale
        h,w = img.shape
        ch = 1
    else:
        h,w,ch = img.shape
    s = img.size
    dt = img.dtype
    print(prefix+" width: %d, height: %d, channel: %d, size: %d, dtype: %s" \
        % (w,h,ch,s,str(dt)))

# Display images and save the result.
def imshow(name, img1, img2):
    print_props("src:",img1)
    print_props("rst:",img2)
    max_height = max(img1.shape[0],img2.shape[0])
    total_width = img1.shape[1] + img2.shape[1]
    img = numpy.zeros((max_height,total_width,3),numpy.uint8)
    if len(img1.shape) == 2:
        img1 = cv2.cvtColor(img1,cv2.COLOR_GRAY2BGR)
    if len(img2.shape) == 2:
        img2 = cv2.cvtColor(img2,cv2.COLOR_GRAY2BGR)    

    img[0:img1.shape[0], 0:img1.shape[1]] = img1
    img[0:img2.shape[0], img1.shape[1]:img.shape[1]] = img2

    # img = cv2.add(img1,img2)
    cv2.imshow(name,img)
    cv2.waitKey(0)
    cv2.imwrite(DSTDIR+"/"+name+".jpg",img)
    print("Saved the image to: "+DSTDIR+"/"+name+".jpg")
    cv2.destroyAllWindows()
