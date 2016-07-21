class TrainDatum < ApplicationRecord
  IMAGE_BASE_PATH = "#{Rails.root}/app/assets/images/train-image"
  IMAGE_BASE_URL  = "/assets/train-image"
  def image_count
    all_image_paths.count
  end

  def label_image_path
    "#{IMAGE_BASE_URL}/#{self.id}/0.jpg"
  end

  def all_image_paths
    image_pattern = "#{IMAGE_BASE_PATH}/#{self.id}/*.jpg"
    Dir.glob(image_pattern).sort.map{|path| "#{IMAGE_BASE_URL}/#{self.id}/#{File.basename(path)}"}
  end
end
