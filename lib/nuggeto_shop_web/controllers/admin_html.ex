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
                  <a
                    href={"/admin/edit/#{item.id}"}
                    class="text-blue-600 hover:text-blue-900 px-2 py-1 bg-blue-50 rounded border border-blue-200 ml-2"
                  >Editar</a>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  def edit(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto py-8 px-4">
      <div class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold">Editar Producto: {@item.name}</h1>
        <a href="/admin" class="text-blue-600 hover:underline">Volver</a>
      </div>

      <div class="bg-white rounded-xl shadow overflow-hidden p-6">
        <form action={"/admin/edit/#{@item.id}"} method="post" class="space-y-6">
          <input type="hidden" name="_csrf_token" value={get_csrf_token()} />
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700">Nombre</label>
              <input type="text" name="item[name]" value={@item.name} class="mt-1 block w-full rounded-md border-gray-300 shadow-sm px-3 py-2 border focus:ring-blue-500 focus:border-blue-500" required />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700">Categoría</label>
              <input type="text" name="item[category]" value={@item.category} class="mt-1 block w-full rounded-md border-gray-300 shadow-sm px-3 py-2 border focus:ring-blue-500 focus:border-blue-500" required />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700">Precio</label>
              <input type="text" name="item[price]" value={@item.price} class="mt-1 block w-full rounded-md border-gray-300 shadow-sm px-3 py-2 border focus:ring-blue-500 focus:border-blue-500" required />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700">Precio de Referencia</label>
              <input type="text" name="item[reference_price]" value={Map.get(@item, :reference_price)} class="mt-1 block w-full rounded-md border-gray-300 shadow-sm px-3 py-2 border focus:ring-blue-500 focus:border-blue-500" />
            </div>
            
            <div class="md:col-span-2">
              <label class="block text-sm font-medium text-gray-700">Estado</label>
              <select name="item[status]" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm px-3 py-2 border focus:ring-blue-500 focus:border-blue-500">
                <option value="available" selected={Map.get(@item, :status, "available") == "available"}>Disponible</option>
                <option value="reserved" selected={Map.get(@item, :status) == "reserved"}>Reservado</option>
                <option value="sold" selected={Map.get(@item, :status) == "sold"}>Vendido</option>
              </select>
            </div>

            <div class="md:col-span-2">
              <label class="block text-sm font-medium text-gray-700">Descripción</label>
              <textarea name="item[description]" rows="4" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm px-3 py-2 border focus:ring-blue-500 focus:border-blue-500" required>{@item.description}</textarea>
            </div>
          </div>

          <div class="flex justify-end mt-6">
            <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-lg transition-colors">Guardar Cambios</button>
          </div>
        </form>
      </div>
    </div>
    """
  end
end
