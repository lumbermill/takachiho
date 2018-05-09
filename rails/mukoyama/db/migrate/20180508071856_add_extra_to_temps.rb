class AddExtraToTemps < ActiveRecord::Migration
  def change
    add_column :temps, :extra1, :string
    add_column :temps, :extra2, :string
    add_column :temps, :extra3, :string
  end
end
