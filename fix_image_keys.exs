json_path = "priv/data/items.json"
items = File.read!(json_path) |> Jason.decode!(keys: :atoms)

fixed_items = Enum.map(items, fn item -> 
  if Map.has_key?(item, :photo_path) do
    item
    |> Map.put(:image, item.photo_path)
    |> Map.delete(:photo_path)
  else
    item
  end
end)

File.write!(json_path, Jason.encode!(fixed_items, pretty: true))
IO.puts("Fixed image keys in items.json!")
