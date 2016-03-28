class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :raspi_id
      t.string :mail
      t.boolean :active

      t.timestamps null: false
    end
  end
end
