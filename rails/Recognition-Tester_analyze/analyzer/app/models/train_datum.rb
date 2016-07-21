class TrainDatum < ApplicationRecord
  def image_count
    image_pattern = "#{Rails.root}/app/assets/images/train-image/#{self.id}/*.jpg"
    Dir.glob(image_pattern).count
  end

  def label_image_path
    "/assets/train-image/#{self.id}/0.jpg"
  end
end
