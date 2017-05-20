class PictureGroup < ActiveRecord::Base
  belongs_to :setting

  def self.basedir(raspi_id)
    raise "raspi_id is not set" unless raspi_id
    PicturesController::BASEDIR+"/#{raspi_id}"
  end
end
