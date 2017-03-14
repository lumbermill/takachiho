require 'rmagick'
require 'fileutils'

# 撮影した豆画像に余白が多かったため、トリミングしています。
# rmagickはメモリリークして途中で止まってしまい使えませんでした。

IMG_DIR = "./coffees_src/"
DST_DIR = './coffees/'

Dir.entries(IMG_DIR).each do |f|
  next unless f.end_with? ".jpg"
  # メモリリークして途中で止まる！！
  # fh = open(IMG_DIR + f,'rb')
  # img = Magick::Image.read(fh).first.crop(128,128,96,96).resize(32,32)
  # img.write(DST_DIR + f)
  # img.destroy! 効果なし!
  # fh.close 効果なし!
  cmd = "convert -crop '128x128+96+96' #{IMG_DIR+f} #{DST_DIR+f}"
  puts cmd
  `#{cmd}`
end
