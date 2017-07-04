json.array!(@settings) do |setting|
  json.extract! setting, :id, :raspi_id, :min_tmpr, :max_tmpr
  json.url setting_url(setting, format: :json)
end
