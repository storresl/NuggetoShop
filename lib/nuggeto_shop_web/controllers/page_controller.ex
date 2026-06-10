defmodule NuggetoShopWeb.PageController do
  use NuggetoShopWeb, :controller

  def home(conn, _params) do
    items = NuggetoShop.Catalog.list_items()
    render(conn, :home, items: items)
  end
end
