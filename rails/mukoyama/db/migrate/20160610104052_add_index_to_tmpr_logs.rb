class AddIndexToTmprLogs < ActiveRecord::Migration
  def change
    add_index :tmpr_logs, [:raspi_id, :time_stamp], unique: true
    add_index :tmpr_daily_logs, [:raspi_id, :time_stamp], unique: true
    add_index :tmpr_monthly_logs, [:raspi_id, :year_month], unique: true
  end
end
