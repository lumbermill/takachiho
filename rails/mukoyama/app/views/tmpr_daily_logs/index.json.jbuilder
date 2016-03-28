json.array!(@tmpr_daily_logs) do |tmpr_daily_log|
  json.extract! tmpr_daily_log, :id, :raspi_id, :time_stamp, :temperature, :pressure, :humidity
  json.url tmpr_daily_log_url(tmpr_daily_log, format: :json)
end
