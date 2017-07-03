class PictureGroup < ActiveRecord::Base
  belongs_to :device

  def self.basedir(device_id)
    raise "raspi_id is not set" unless device_id
    PicturesController::BASEDIR+"/#{device_id}"
  end
end
