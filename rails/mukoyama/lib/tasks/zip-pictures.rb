

def cmd(cmd)
  puts cmd
  res = `#{cmd}`
  unless res.empty? && $? == 0
    puts res
  end
end

def main(device_id)
  unless device_id > 0
    print "device_id is not determined."
    return
  end
  dir = "/var/www/mukoyama/downloads/#{device_id}-pictures"

  # 作業用ディレクトリを作成、既存のものがあれば削除
  cmd("rm #{dir}.zip") if File.file? dir+".zip"
  cmd("rm -r #{dir}") if File.directory? dir
  cmd("mkdir #{dir}")

  # 作業用ディレクトリに画像を書き出し TODO:
  # for debug:
  # sleep(20)
  # cmd("cd #{dir} && touch dummy.jpg")

  n = 0
  Picture.where(device_id: device_id).order("dt").each do |pic|
    name = pic.dt.strftime("%y%m%d_%H%M%S")+".jpg"
    File.open(dir+"/"+name,"wb").write(pic.data)
    n += 1
  end

  # zip圧縮
  cmd("cd #{dir}/../ && zip #{device_id}-pictures.zip #{device_id}-pictures/*")

  # 作業ファイルを削除
  cmd("rm -r #{dir}") if File.directory? dir

end

# ruby zip-pictures.rb device_id
main(ARGV[0].to_i)
