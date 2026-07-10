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
    item_params =
      if upload = item_params["image"] do
        item = NuggetoShop.Catalog.get_item(id)
        content_type = upload.content_type || "image/jpeg"
        binary = File.read!(upload.path)
        base64 = Base.encode64(binary)
        Map.put(item_params, "image", "data:#{content_type};base64,#{base64}")
      else
        item_params
      end

    NuggetoShop.Catalog.update_item(id, item_params)

    conn
    |> put_flash(:info, "Producto actualizado correctamente.")
    |> redirect(to: ~p"/admin")
  end

  def fix_db(conn, _params) do
    Ecto.Adapters.SQL.query!(NuggetoShop.Repo, "SELECT setval('items_id_seq', (SELECT MAX(id) FROM items))")
    text(conn, "DB Fixed")
  end

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"item" => item_params}) do
    item_params =
      if upload = item_params["image"] do
        content_type = upload.content_type || "image/jpeg"
        binary = File.read!(upload.path)
        base64 = Base.encode64(binary)
        Map.put(item_params, "image", "data:#{content_type};base64,#{base64}")
      else
        item_params
      end

    case NuggetoShop.Catalog.create_item(item_params) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Producto creado correctamente.")
        |> redirect(to: ~p"/admin")
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Error al crear el producto. Revisa los datos.")
        |> redirect(to: ~p"/admin/new")
    end
  end

  def delete(conn, %{"id" => id}) do
    item = NuggetoShop.Catalog.get_item(id)
    
    # Note: We won't delete old images if they were base64 or static.
    # Local ephemeral filesystem handles garbage collection anyway.

    NuggetoShop.Catalog.delete_item(id)

    conn
    |> put_flash(:info, "Producto eliminado correctamente.")
    |> redirect(to: ~p"/admin")
  end
end
