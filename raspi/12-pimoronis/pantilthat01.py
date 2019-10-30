import picamera, time
import pantilthat as pt

cam = picamera.PiCamera()
cam.hflip = True
cam.vflip = True

pt.pan(0)
pt.tilt(0)
time.sleep(1)
pt.pan(-12)
time.sleep(1)
pt.tilt(12)
time.sleep(1)
pt.tilt(0)
time.sleep(1)
pt.pan(12)
time.sleep(1)
pt.tilt(12)
time.sleep(1)
pt.tilt(0)
time.sleep(1)
pt.pan(0)
time.sleep(1)

cam.start_preview()
time.sleep(2)
cam.capture('test.jpg')

