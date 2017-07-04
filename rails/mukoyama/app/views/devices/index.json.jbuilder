json.array!(@settings) do |setting|
  json.extract! setting, :id, :raspi_id, :temp_min, :temp_max
  json.url setting_url(setting, format: :json)
end
