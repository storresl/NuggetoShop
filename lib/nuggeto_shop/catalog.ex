defmodule NuggetoShop.Catalog do
  @file_path "priv/data/items.json"

  def list_items(params \\ %{}) do
    items =
      @file_path
      |> File.read!()
      |> Jason.decode!(keys: :atoms)

    category = Map.get(params, "category")
    query = Map.get(params, "q")

    items
    |> filter_by_category(category)
    |> filter_by_query(query)
  end

  defp filter_by_category(items, nil), do: items
  defp filter_by_category(items, "Todo"), do: items
  defp filter_by_category(items, category), do: Enum.filter(items, &(&1.category == category))

  defp filter_by_query(items, nil), do: items
  defp filter_by_query(items, ""), do: items

  defp filter_by_query(items, query) do
    query = String.downcase(query)

    Enum.filter(items, fn item ->
      String.downcase(item.name) =~ query or String.downcase(item.description) =~ query
    end)
  end
end
