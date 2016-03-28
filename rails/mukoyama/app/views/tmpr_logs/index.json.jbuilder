json.array!(@tmpr_logs) do |tmpr_log|
  json.extract! tmpr_log, :id, :raspi_id, :time_stamp, :temperature, :pressure, :humidity
  json.url tmpr_log_url(tmpr_log, format: :json)
end
