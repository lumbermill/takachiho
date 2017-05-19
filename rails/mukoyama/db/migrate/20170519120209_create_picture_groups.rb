class CreatePictureGroups < ActiveRecord::Migration
  def change
    create_table :picture_groups do |t|
      t.integer :user_id, null: false
      t.boolean :starred, null: false, default: false
      t.bigint :head, null: false
      t.bigint :tail, null: false
      t.integer :n, null: false, default: 0

      t.timestamps null: false
    end
  end
end
