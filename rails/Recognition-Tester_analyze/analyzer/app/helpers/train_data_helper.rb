module TrainDataHelper
  def train_image_count(id)
    image_pattern = "#{Rails.root}/app/assets/images/train-image/#{id}/*.jpg"
    Dir.glob(image_pattern).count
  end
end
