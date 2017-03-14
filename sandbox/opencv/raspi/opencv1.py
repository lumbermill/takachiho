import io, time, picamera
import cv2
import numpy

stream = io.BytesIO()
with picamera.PiCamera() as camera:
  camera.start_preview()
  time.sleep(2)
  camera.capture(stream, format='jpeg')

data = numpy.fromstring(stream.getvalue(), dtype=numpy.uint8)
image = cv2.imdecode(data, 1)
image = image[:, :, ::-1]

