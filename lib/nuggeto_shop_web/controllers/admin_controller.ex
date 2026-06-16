defmodule NuggetoShopWeb.AdminController do
  use NuggetoShopWeb, :controller

  def index(conn, _params) do
    items = NuggetoShop.Catalog.list_items()
    render(conn, :index, items: items)
  end

  def update_status(conn, %{"id" => id, "status" => status}) do
    if status in ["available", "sold"] do
      NuggetoShop.Catalog.update_item(id, %{"status" => status})
    end

    redirect(conn, to: ~p"/admin")
  end

  def edit(conn, %{"id" => id}) do
    item = NuggetoShop.Catalog.get_item(id)
    render(conn, :edit, item: item)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    NuggetoShop.Catalog.update_item(id, item_params)

    conn
    |> put_flash(:info, "Producto actualizado correctamente.")
    |> redirect(to: ~p"/admin")
  end
end
