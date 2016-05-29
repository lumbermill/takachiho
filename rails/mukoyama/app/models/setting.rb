class Setting < ActiveRecord::Base
  has_many :addresses, foreign_key: :raspi_id
  belongs_to :user
end
