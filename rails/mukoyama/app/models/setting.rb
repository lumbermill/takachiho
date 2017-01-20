class Setting < ActiveRecord::Base
  has_many :addresses, foreign_key: :raspi_id
  belongs_to :user
  has_many :sakura_iot_modules, foreign_key: :raspi_id#, dependent: :destroy
  accepts_nested_attributes_for :sakura_iot_modules, reject_if: :new_record?

  # Returns true if the sensor is visible via the link with token(without authentication).
  def readable?
    token4read != nil && token4read.length > 0
  end
end
