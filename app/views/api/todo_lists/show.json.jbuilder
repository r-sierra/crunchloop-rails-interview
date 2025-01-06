json.(@todo_list, :id, :name)
json.items @todo_list.items, :id, :text, :created_at, :updated_at
