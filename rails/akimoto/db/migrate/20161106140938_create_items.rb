class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.bigint :code,      null: false
      t.integer :user_id,  null: false
      t.integer :revision, null: false, default: 1
      t.string :maker,     null: false, default: ""
      t.string :name,      null: false, default: ""
      t.string :size,      null: false, default: ""
      t.integer :price,    null: false, default: 0
      t.binary :picture,   limit: 16777215

      t.timestamps null: false
    end
    add_index :items, [:code, :user_id, :revision], unique: true
  end
end