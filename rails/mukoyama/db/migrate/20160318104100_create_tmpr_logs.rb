class CreateTmprLogs < ActiveRecord::Migration
  def change
    create_table :tmpr_logs do |t|
      t.integer :raspi_id
      t.datetime :time_stamp
      t.float :temperature
      t.float :pressure
      t.float :humidity

      t.timestamps null: false
    end
  end
end
