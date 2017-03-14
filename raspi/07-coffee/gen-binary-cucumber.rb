require 'csv'
require 'rmagick'
require 'fileutils'

SIZE = 32
IMG_DIR = "./cucumbers/"
BIN_DIR = './'

puts "start..."

# CSVの代わりにファイル名の先頭をラベルにする
# cocoroのようにフォルダ名=ラベルの方が作業はし易いかな…
names = {"2L":0,"L":1,"M":2,"S":3,"2S":4,"BL":5,"BM":6,"BS":7,"C":8}

file = String.new
Dir.entries(IMG_DIR).each do |f|
  next unless f.end_with? ".jpg"
  buf = String.new
  puts f
  clazz = names[f.split("_")[0]]
  clazz = 9 if clazz.nil?
  buf << [clazz].pack('C')
  img = Magick::Image.read(open(IMG_DIR + f,'rb')).first.resize(SIZE,SIZE)
  %w(red green blue).each do |color|
   img.each_pixel do |px|
    buf << [px.send(color) >> 8].pack('C')
   end
  end
  file << buf
end

# TODO: data_batchは複数に分ける必要がある？
FileUtils.mkdir_p(BIN_DIR) unless FileTest.exist?(BIN_DIR)
if(ARGV[0] == 'train')
  File.binwrite(BIN_DIR + "data_batch_1.bin", file)
else
  File.binwrite(BIN_DIR + "test_batch.bin", file)
end
