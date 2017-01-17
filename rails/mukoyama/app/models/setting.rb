class Setting < ActiveRecord::Base
  has_many :addresses, foreign_key: :raspi_id
  belongs_to :user

  # Returns true if the sensor is visible via the link with token(without authentication).
  def readable?
    token4read != nil && token4read.length > 0
  end
end
