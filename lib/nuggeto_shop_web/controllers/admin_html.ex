defmodule NuggetoShopWeb.AdminHTML do
  use NuggetoShopWeb, :html

  def index(assigns) do
    ~H"""
    <div class="max-w-6xl mx-auto py-8 px-4">
      <div class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold">Admin Dashboard</h1>
        <a href="/" class="text-blue-600 hover:underline">Volver a la tienda</a>
      </div>

      <div class="bg-white rounded-xl shadow overflow-hidden">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th
                scope="col"
                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >
                ID
              </th>
              <th
                scope="col"
                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >
                Producto
              </th>
              <th
                scope="col"
                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >
                Precio
              </th>
              <th
                scope="col"
                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >
                Estado
              </th>
              <th
                scope="col"
                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >
                Acciones
              </th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <%= for item <- @items do %>
              <tr>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">#{item.id}</td>
                <td class="px-6 py-4 text-sm text-gray-900 font-medium">{item.name}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{item.price}</td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <%= case Map.get(item, :status, "available") do %>
                    <% "available" -> %>
                      <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Disponible</span>
                    <% "reserved" -> %>
                      <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">Reservado</span>
                    <% "sold" -> %>
                      <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">Vendido</span>
                  <% end %>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium flex gap-2">
                  <form action={"/admin/status/#{item.id}"} method="post">
                    <input type="hidden" name="_csrf_token" value={get_csrf_token()} />
                    <input type="hidden" name="status" value="available" />
                    <button
                      type="submit"
                      class="text-green-600 hover:text-green-900 px-2 py-1 bg-green-50 rounded border border-green-200"
                    >Disponible</button>
                  </form>
                  <form action={"/admin/status/#{item.id}"} method="post">
                    <input type="hidden" name="_csrf_token" value={get_csrf_token()} />
                    <input type="hidden" name="status" value="sold" />
                    <button
                      type="submit"
                      class="text-gray-600 hover:text-gray-900 px-2 py-1 bg-gray-50 rounded border border-gray-200"
                    >Vendido</button>
                  </form>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>
    """
  end
end
