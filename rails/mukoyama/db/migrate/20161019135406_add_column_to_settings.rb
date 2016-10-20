class AddColumnToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :token, :string
    execute "UPDATE settings SET token = raspi_id"
    add_index :settings, [:token], unique: true
  end
end
