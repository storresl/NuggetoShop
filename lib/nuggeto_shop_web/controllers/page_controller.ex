defmodule NuggetoShopWeb.PageController do
  use NuggetoShopWeb, :controller

  def home(conn, params) do
    items = NuggetoShop.Catalog.list_items(params)
    categories = NuggetoShop.Catalog.list_categories()

    active_category = Map.get(params, "category", "Todo")
    search_query = Map.get(params, "q", "")
    hide_unavailable = Map.get(params, "hide_unavailable") == "true"

    render(conn, :home,
      items: items,
      categories: categories,
      active_category: active_category,
      search_query: search_query,
      hide_unavailable: hide_unavailable
    )
  end

  def reserve(conn, %{"id" => id}) do
    item = NuggetoShop.Catalog.get_item(id)

    if item && Map.get(item, :status, "available") == "available" do
      NuggetoShop.Catalog.reserve(id)

      whatsapp_msg =
        URI.encode(
          "¡Hola! Acabo de reservar el producto: #{item.name} en la tienda. Me gustaría coordinar el pago."
        )

      redirect_url = "https://wa.me/56978906532?text=#{whatsapp_msg}"

      redirect(conn, external: redirect_url)
    else
      redirect(conn, to: ~p"/")
    end
  end
end
