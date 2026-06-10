defmodule NuggetoShopWeb.PageController do
  use NuggetoShopWeb, :controller

  def home(conn, params) do
    items = NuggetoShop.Catalog.list_items(params)

    active_category = Map.get(params, "category", "Todo")
    search_query = Map.get(params, "q", "")

    render(conn, :home,
      items: items,
      active_category: active_category,
      search_query: search_query
    )
  end
end
