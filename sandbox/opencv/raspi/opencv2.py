import time
import picamera
import picamera.array
import cv2

with picamera.PiCamera() as camera:
  camera.start_preview()
  time.sleep(2)
  with picamera.array.PiRGBArray(camera) as stream:
    camera.capture(stream, format='bgr')
    image = stream.array

