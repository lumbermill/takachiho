json.array!(@tmpr_monthly_logs) do |tmpr_monthly_log|
  json.extract! tmpr_monthly_log, :id, :raspi_id, :year_month, :temperature, :pressure, :humidity
  json.url tmpr_monthly_log_url(tmpr_monthly_log, format: :json)
end
