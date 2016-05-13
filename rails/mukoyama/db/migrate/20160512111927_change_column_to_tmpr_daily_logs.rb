class ChangeColumnToTmprDailyLogs < ActiveRecord::Migration
  def change
    add_column :tmpr_daily_logs, :temperature_max, :float
  	add_column :tmpr_daily_logs, :pressure_max, :float
  	add_column :tmpr_daily_logs, :humidity_max, :float
    add_column :tmpr_daily_logs, :temperature_min, :float
  	add_column :tmpr_daily_logs, :pressure_min, :float
  	add_column :tmpr_daily_logs, :humidity_min, :float
    rename_column :tmpr_daily_logs, :temperature, :temperature_average
  	rename_column :tmpr_daily_logs, :pressure, :pressure_average
  	rename_column :tmpr_daily_logs, :humidity, :humidity_average

    add_column :tmpr_monthly_logs, :temperature_max, :float
  	add_column :tmpr_monthly_logs, :pressure_max, :float
  	add_column :tmpr_monthly_logs, :humidity_max, :float
    add_column :tmpr_monthly_logs, :temperature_min, :float
  	add_column :tmpr_monthly_logs, :pressure_min, :float
  	add_column :tmpr_monthly_logs, :humidity_min, :float
    rename_column :tmpr_monthly_logs, :temperature, :temperature_average
  	rename_column :tmpr_monthly_logs, :pressure, :pressure_average
  	rename_column :tmpr_monthly_logs, :humidity, :humidity_average
  end
end
