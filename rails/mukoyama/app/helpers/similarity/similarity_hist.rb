#! /usr/bin/env ruby

require 'opencv'
require 'pp'
class HistGrayScale
  include OpenCV
  IMG_SIZE = CvSize.new(200, 200)

  def self.histgram(image_filename)
    image = IplImage.load(image_filename) # Read the file.
    image.resize(IMG_SIZE)
    # TODO: 色を使って比較する
    gray = image.BGR2GRAY
    dim = 1 
    size = [256]
    hist = CvHistogram.new(dim, size, CV_HIST_ARRAY, [[0,255]])
    hist.calc_hist([gray])
  end

  def self.compare(image1, image2)
    hist1 = histgram(image1)
    hist2 = histgram(image2)
    similarity = CvHistogram.compare_hist(hist1,hist2,CV_COMP_CORREL)
  end
end

class HistRGB
  include OpenCV
  IMG_SIZE = CvSize.new(200, 200)

  def self.histgram(image_filename)
    image = IplImage.load(image_filename) # Read the file.
    image.resize(IMG_SIZE)

#    n = 50
#    image = (image/n).mul n #減色

    b, g, r = image.split # Split RGB image to 1ch image array [b, g, r]
    dim = 3 
    sizes = [8,8,8]
    ranges = [[0, 255],[0, 255],[0, 255]]
    hist = CvHistogram.new(dim, sizes, CV_HIST_ARRAY, ranges)
    hist.calc_hist([r,g,b])
  end

  def self.compare(image1, image2)
    hist1 = histgram(image1)
    hist2 = histgram(image2)
    similarity = CvHistogram.compare_hist(hist1,hist2,CV_COMP_CORREL)
  end
end

if $0 == __FILE__
  include HistGrayScale
  hist1 = histgram(ARGV[0])
  hist2 = histgram(ARGV[1])
  similarity = CvHistogram.compare_hist(hist1,hist2,CV_COMP_CORREL)
  p similarity
end
