class AddIndexToSettings < ActiveRecord::Migration
  def change
    add_index :settings, [:raspi_id], name: "index_settings_on_raspi_id", unique: true 
  end
end
