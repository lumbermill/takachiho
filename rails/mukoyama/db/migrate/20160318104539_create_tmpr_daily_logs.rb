class CreateTmprDailyLogs < ActiveRecord::Migration
  def change
    create_table :tmpr_daily_logs do |t|
      t.integer :raspi_id
      t.date :time_stamp
      t.float :temperature
      t.float :pressure
      t.float :humidity

      t.timestamps null: false
    end
  end
end
