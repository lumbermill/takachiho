class Item < ActiveRecord::Base
  belongs_to :user
  has_many :tags

  def picture_path
    "/pictures/#{user_id}/#{code}-#{revision}.jpg"
  end


  def picture
    "<img src='#{picture_path}' alt='' class='img img-responsive'/>".html_safe
  end
end
