require 'csv'
require 'rmagick'
require 'fileutils'

SIZE = 32
IMG_DIR = "./coffees/"
BIN_DIR = './'

# ディレクトリ名をラベルにする
names = {"good":0,"bad":1}

file = String.new
names.each do |k,v|
  Dir.entries(IMG_DIR+k.to_s).each do |f|
    next unless f.end_with? ".jpg"
    buf = String.new
    puts k.to_s+"/"+f
    buf << [v].pack('C')
    img = Magick::Image.read(open(IMG_DIR+k.to_s+"/"+f,'rb')).first.resize(SIZE,SIZE)
    %w(red green blue).each do |color|
     img.each_pixel do |px|
      buf << [px.send(color) >> 8].pack('C')
     end
    end
    file << buf
  end
end

# TODO: data_batchは複数に分ける必要がある？
FileUtils.mkdir_p(BIN_DIR) unless FileTest.exist?(BIN_DIR)
File.binwrite(BIN_DIR + "data_batch_1.bin", file)
