class Tag < ActiveRecord::Base
  has_many :items
end
