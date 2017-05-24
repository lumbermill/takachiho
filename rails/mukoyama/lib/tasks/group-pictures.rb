

def debug?
  true
end

def clear(raspi_id)
  conn = ActiveRecord::Base.connection
  conn.execute("delete from picture_groups where raspi_id = #{raspi_id}")
end

# ex. 123123_456456.jpg -> 123123456456
# ex. foo.jpg -> nil
def filename2seq(name)
  m = name.sub("_","").match(/([0-9]{12}).jpg/)
  return nil unless m
  return m[1].to_i
end

# ex. 123123456456 -> /opt/mukoyama.lmlab.net/data/pictures/9/123123_456456.jpg
def seq2filepath(basedir,seq)
  n = seq.to_s
  basedir+"/"+n[0,6]+"_"+n[6,6]+".jpg"
end

def similar?(p1,p2)
  # TODO: ここ実装する、アルゴリズム色々切り替えられたら面白そう
  # これは10分単位でまとめる場合
  # p1 / 1000 == p2 / 1000

  cmd = "python3 #{__dir__}/compare-hist.py #{p1} #{p2}"
  ret = `#{cmd}`.strip.to_f
  if $? != 0 || ret == 0
    raise "Failed: #{cmd}"
  end
  ret > 0.95
end

def update(raspi_id)
  start = PictureGroup.where(raspi_id: raspi_id).maximum(:head) || 0
  puts "start=#{start}" if debug?
  basedir = PictureGroup.basedir(raspi_id)
  raise "#{basedir} not found." unless File.directory? basedir
  pictures = []
  Dir.entries(basedir).sort.each do |f|
    p = filename2seq(f)
    next if p.nil? || p <= start
    pictures += [p]
  end
  return if pictures.count == 0
  puts "#{pictures.count} pictures(on #{basedir}) will be processed."
  tail = pictures[0]
  n = 0
  (0..pictures.count-2).each do |i|
    p = pictures[i]
    p_next = pictures[i+1]
    n += 1
    next if similar?(seq2filepath(basedir,p),seq2filepath(basedir,p_next))
    PictureGroup.create(raspi_id: raspi_id, head: p, tail: tail, n: n)
    n = 0
    tail = p_next
  end
  PictureGroup.create(raspi_id: raspi_id, head: pictures[-1], tail: tail, n: n)

end

if __FILE__ == $0
  # test
  clear(1)
  update(1)
end
