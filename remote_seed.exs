alias NuggetoShop.Repo
alias NuggetoShop.Catalog.Item

json_path = Application.app_dir(:nuggeto_shop, "priv/data/items.json")

items_json = 
  json_path
  |> File.read!()
  |> Jason.decode!(keys: :atoms)

now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

items_to_insert = 
  Enum.map(items_json, fn item_data ->
    %{
      id: item_data[:id],
      name: item_data[:name],
      category: item_data[:category],
      description: item_data[:description],
      image: item_data[:image],
      price: item_data[:price],
      reference_price: item_data[:reference_price],
      status: item_data[:status],
      reserved_until: item_data[:reserved_until],
      inserted_at: now,
      updated_at: now
    }
  end)

Repo.insert_all(Item, items_to_insert, on_conflict: :replace_all, conflict_target: :id)

IO.puts "Successfully migrated data from items.json to Postgres DB using insert_all!"
