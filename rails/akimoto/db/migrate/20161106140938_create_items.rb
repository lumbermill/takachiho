class CreateItems < ActiveRecord::Migration[4.2]
  def change
    create_table :items do |t|
      t.bigint :code,      null: false
      t.integer :user_id,  null: false
      t.integer :revision, null: false, default: 1
      t.string :maker,     null: false, default: ""
      t.string :name,      null: false, default: ""
      t.string :size,      null: false, default: ""
      t.integer :price,    null: false, default: 0
      t.integer :picture_main, null: false, default: 1
      t.integer :picture_latest, null: false, default: 1
      t.string :memo,      null: false, default: ""

      t.timestamps null: false
    end
    add_index :items, [:code, :user_id, :revision], unique: true
  end
end
