# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

alias NuggetoShop.Repo
alias NuggetoShop.Catalog.Item

json_path = "priv/data/items.json"

if File.exists?(json_path) do
  items_json = 
    json_path
    |> File.read!()
    |> Jason.decode!(keys: :atoms)

  for item_data <- items_json do
    %Item{id: item_data[:id]}
    |> Item.changeset(%{
      name: item_data[:name],
      category: item_data[:category],
      description: item_data[:description],
      image: item_data[:image],
      price: item_data[:price],
      reference_price: item_data[:reference_price],
      status: item_data[:status],
      reserved_until: item_data[:reserved_until]
    })
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :id)
  end
  
  IO.puts "Successfully migrated data from items.json to Postgres DB!"
else
  IO.puts "No items.json found. Skipping seed."
end
