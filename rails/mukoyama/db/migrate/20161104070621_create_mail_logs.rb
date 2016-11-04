class CreateMailLogs < ActiveRecord::Migration
  def change
    create_table :mail_logs do |t|
      t.integer :address_id
      t.datetime :time_stamp
      t.boolean :delivered
      t.timestamps null: false
    end
  end
end
