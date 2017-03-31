class AddMotionSensorToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :motion_sensor, :boolean
  end
end
