class SakuraIotModule < ActiveRecord::Base
	belongs_to :settings, foreign_key: :raspi_id
end
