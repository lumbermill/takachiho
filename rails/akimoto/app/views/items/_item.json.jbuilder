json.extract! item, :id, :code, :user_id, :revision, :maker, :name, :size, :price, :picture, :created_at, :updated_at
json.url item_url(item, format: :json)