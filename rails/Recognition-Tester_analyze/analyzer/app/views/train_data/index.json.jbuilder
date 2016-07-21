json.array!(@train_data) do |train_datum|
  json.extract! train_datum, :id
  json.url train_datum_url(train_datum, format: :json)
end
