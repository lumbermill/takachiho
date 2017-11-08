require 'zip' #何故か自動でロードされない
class Picture < ActiveRecord::Base
  belongs_to :device
  DOWNLOAD_DIR = "/var/www/mukoyama/downloads"

  def self.save_to_zip(device_id, date="", limit=nil)
    zip_path = DOWNLOAD_DIR+"/#{device_id}-#{date}-pictures.zip"
    FileUtils.rm(zip_path) if File.exist?(zip_path)

    if date == ""
      pictures = Picture.where("device_id = ?", device_id).order("dt desc").limit(limit)
    else
      time_start = Time.zone.parse(date) # ex. Time.zone.parse('2017-11-07') => 2017-11-07 00:00:00 +0900
      time_end = time_start.tomorrow
      pictures = Picture.where("device_id = ? and ? <= dt and dt < ?", device_id, time_start, time_end).order("dt desc").limit(limit)
    end
    Dir.mktmpdir do |dir|
      pic_files = []
      pictures.each do |p|
        name = p.dt.strftime("%y%m%d_%H%M%S")+".jpg"
        File.open(dir+"/"+name,"wb").write(p.data)
        pic_files << name
      end
      Zip::File.open(zip_path, Zip::File::CREATE) do |zipfile|
        pic_files.each do |p, i|
          zipfile.add(p, dir + "/"+p)
        end
      end
    end
    zip_path
  end
end
