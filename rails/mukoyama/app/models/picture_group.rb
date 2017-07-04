class PictureGroup < ActiveRecord::Base
  belongs_to :device

  def self.basedir(device_id)
    raise "device_id is not set" unless device_id
    PicturesController::BASEDIR+"/#{device_id}"
  end
end
