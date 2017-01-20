class CreateSakuraIotModules < ActiveRecord::Migration
  def change
    create_table :sakura_iot_modules do |t|
      t.integer :raspi_id
      t.string :token
      t.timestamps null: false
    end
    add_index :sakura_iot_modules, [:raspi_id], unique: true
  end
end
