json.array!(@addresses) do |address|
  json.extract! address, :id, :raspi_id, :mail, :active
  json.url address_url(address, format: :json)
end
