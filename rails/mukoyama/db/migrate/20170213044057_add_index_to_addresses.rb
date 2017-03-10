class AddIndexToAddresses < ActiveRecord::Migration
  def change
    add_index :addresses, [:raspi_id, :mail], unique: true
  end
end
