#! /usr/bin/env ruby

require 'opencv'
require 'pp'
include OpenCV
IMG_SIZE = CvSize.new(200, 200)

def histgram(image_filename)
  image = IplImage.load(image_filename) # Read the file.
  image.resize(IMG_SIZE)
  # TODO: 色を使って比較する
  gray = image.BGR2GRAY
  window = GUI::Window.new(image_filename) # create a window for display.
  window.show(gray) # show our image inside it.
  GUI::wait_key # Wait for a keystroke in the window.

  dim = 1 
  size = [256]
  hist = CvHistogram.new(dim, size, CV_HIST_ARRAY, [[0,255]])
  hist.calc_hist([gray])
end

hist1 = histgram(ARGV[0])
hist2 = histgram(ARGV[1])
similarity = CvHistogram.compare_hist(hist1,hist2,CV_COMP_CORREL)
p similarity
