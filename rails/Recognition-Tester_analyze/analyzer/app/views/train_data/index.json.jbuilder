json.array!(@train_data) do |train_datum|
  json.extract! train_datum, :id, :jan, :label, :image_count, :label_image_path
  json.url train_datum_url(train_datum, format: :json)
end
