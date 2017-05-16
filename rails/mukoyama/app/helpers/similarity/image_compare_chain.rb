require 'fileutils'
require './similarity_hist.rb'
include FileUtils



def compare_chain(image_dir, comparator)
  prev_img = nil
  Dir.open(image_dir).each do |image|
    next if image =~ /^\./
    if prev_img
      similarity = comparator.compare(image_dir + "/" + prev_img, image_dir + "/" + image)
      yield(prev_img, image, similarity)
    end
    prev_img = image
  end
end

def print_comparation(comparator)
  open("#{RESULT_DIR}/#{comparator}.html","w") do |out|
    out.puts '<html><body>'
    out.puts "<h1>#{comparator}</h1>"
    out.puts '<table><tr><td>'
    print_comparation_inner(IMAGE_DIR1, comparator, out)
    out.puts '</td><td>'
    print_comparation_inner(IMAGE_DIR2, comparator, out)
    out.puts '</td></tr><table>'
    out.puts '</body></html>'
  end
end

def print_comparation_inner(image_dir,comparator, out)
  out.puts "<h2>#{image_dir}</h2>";
  out.puts '<table>'
  compare_chain(image_dir, comparator) do |prev_image, image, similarity|
    out.printf("<tr><td><img src='%s' width='200px'/><br>%s</td><td><img src='%s' width='200px'/><br>%s</td><td>%.3f</td></tr>\n",
               "../#{image_dir}/#{prev_image}", prev_image, "../#{image_dir}/#{image}", image, similarity)
  end
  out.puts '</table>'
end

IMAGE_DIR1 = './test-picture/takachiho-city'
IMAGE_DIR2 = './test-picture/yunokino'
RESULT_DIR = './result'
print_comparation(HistGrayScale)
print_comparation(HistRGB)
