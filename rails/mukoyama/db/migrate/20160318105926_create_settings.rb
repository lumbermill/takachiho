class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :raspi_id
      t.float :min_tmpr
      t.float :max_tmpr

      t.timestamps null: false
    end
  end
end
