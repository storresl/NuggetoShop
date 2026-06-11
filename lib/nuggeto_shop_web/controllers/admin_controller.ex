defmodule NuggetoShopWeb.AdminController do
  use NuggetoShopWeb, :controller

  def index(conn, _params) do
    items = NuggetoShop.Catalog.list_items()
    render(conn, :index, items: items)
  end

  def update_status(conn, %{"id" => id, "status" => status}) do
    case status do
      "available" -> NuggetoShop.Catalog.mark_available(id)
      "sold" -> NuggetoShop.Catalog.mark_sold(id)
      _ -> :ok
    end

    redirect(conn, to: ~p"/admin")
  end
end
