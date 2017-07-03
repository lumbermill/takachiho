class SakuraIotModule < ActiveRecord::Base
	belongs_to :devices, foreign_key: :device_id
end
