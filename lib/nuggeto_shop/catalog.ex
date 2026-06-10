defmodule NuggetoShop.Catalog do
  @file_path "priv/data/items.json"

  def list_items do
    @file_path
    |> File.read!()
    |> Jason.decode!(keys: :atoms)
  end
end
