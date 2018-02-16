class CreateTags < ActiveRecord::Migration[4.2]
  def change
    create_table :tags do |t|
      t.integer :item_id, null: false
      t.string :name,     null: false, default: ""

      t.timestamps null: false
    end
  end
end
