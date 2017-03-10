class AddCityIdToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :city_id, :bigint
  end
end
