defmodule NuggetoShop.Catalog do
  use GenServer
  require Logger

  @file_path "priv/data/items.json"
  # 2 hours in ms
  @reservation_time_ms 2 * 60 * 60 * 1000

  # --- Client API ---

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def list_items(params \\ %{}) do
    GenServer.call(__MODULE__, {:list_items, params})
  end

  def get_item(id) do
    GenServer.call(__MODULE__, {:get_item, id})
  end

  def reserve(id) do
    GenServer.cast(__MODULE__, {:reserve, id})
  end

  def mark_sold(id) do
    GenServer.cast(__MODULE__, {:update_status, id, "sold"})
  end

  def mark_available(id) do
    GenServer.cast(__MODULE__, {:update_status, id, "available"})
  end

  # --- Server Callbacks ---

  @impl true
  def init(_state) do
    items = load_from_disk()

    # Process initial timers and expire outdated reservations
    now = System.system_time(:millisecond)

    items =
      Enum.map(items, fn item ->
        case item do
          %{status: "reserved", reserved_until: reserved_until} ->
            if now >= reserved_until do
              %{item | status: "available", reserved_until: nil}
            else
              # Schedule expiration for remaining time
              Process.send_after(self(), {:expire_reservation, item.id}, reserved_until - now)
              item
            end

          _ ->
            # Default missing statuses to available
            item |> Map.put_new(:status, "available") |> Map.put_new(:reserved_until, nil)
        end
      end)

    persist_to_disk(items)
    {:ok, items}
  end

  @impl true
  def handle_call({:list_items, params}, _from, items) do
    category = Map.get(params, "category")
    query = Map.get(params, "q")

    filtered_items =
      items
      |> filter_by_category(category)
      |> filter_by_query(query)

    {:reply, filtered_items, items}
  end

  @impl true
  def handle_call({:get_item, id}, _from, items) do
    id_int = if is_binary(id), do: String.to_integer(id), else: id
    item = Enum.find(items, &(&1.id == id_int))
    {:reply, item, items}
  end

  @impl true
  def handle_cast({:reserve, id}, items) do
    id_int = if is_binary(id), do: String.to_integer(id), else: id
    now = System.system_time(:millisecond)
    reserved_until = now + @reservation_time_ms

    new_items =
      Enum.map(items, fn item ->
        if item.id == id_int and Map.get(item, :status, "available") == "available" do
          Process.send_after(self(), {:expire_reservation, item.id}, @reservation_time_ms)
          %{item | status: "reserved", reserved_until: reserved_until}
        else
          item
        end
      end)

    persist_to_disk(new_items)
    {:noreply, new_items}
  end

  @impl true
  def handle_cast({:update_status, id, new_status}, items) do
    id_int = if is_binary(id), do: String.to_integer(id), else: id

    new_items =
      Enum.map(items, fn item ->
        if item.id == id_int do
          %{item | status: new_status, reserved_until: nil}
        else
          item
        end
      end)

    persist_to_disk(new_items)
    {:noreply, new_items}
  end

  @impl true
  def handle_info({:expire_reservation, id}, items) do
    new_items =
      Enum.map(items, fn item ->
        if item.id == id and item.status == "reserved" do
          Logger.info("Reservation expired for item #{id}")
          %{item | status: "available", reserved_until: nil}
        else
          item
        end
      end)

    persist_to_disk(new_items)
    {:noreply, new_items}
  end

  # --- Internal Helpers ---

  defp load_from_disk do
    @file_path
    |> File.read!()
    |> Jason.decode!(keys: :atoms)
  end

  defp persist_to_disk(items) do
    # Pretty print JSON for easy debugging and human readability
    json = Jason.encode!(items, pretty: true)
    File.write!(@file_path, json)
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
