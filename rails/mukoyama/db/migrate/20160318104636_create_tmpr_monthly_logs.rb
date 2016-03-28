class CreateTmprMonthlyLogs < ActiveRecord::Migration
  def change
    create_table :tmpr_monthly_logs do |t|
      t.integer :raspi_id
      t.integer :year_month
      t.float :temperature
      t.float :pressure
      t.float :humidity

      t.timestamps null: false
    end
  end
end
