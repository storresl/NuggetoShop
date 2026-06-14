defmodule NuggetoShop.Catalog do
  use GenServer
  require Logger
  import Ecto.Query
  alias NuggetoShop.Repo
  alias NuggetoShop.Catalog.Item

  # 2 hours in ms
  @reservation_time_ms 2 * 60 * 60 * 1000

  # --- Client API ---

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def list_items(params \\ %{}) do
    query = from i in Item, order_by: [asc: i.id]
    
    query = 
      if category = Map.get(params, "category") do
        if category == "Todo" do
          query
        else
          from i in query, where: i.category == ^category
        end
      else
        query
      end

    query = 
      if search = Map.get(params, "q") do
        if search == "" do
          query
        else
          search_term = "%#{String.downcase(search)}%"
          from i in query, where: ilike(i.name, ^search_term) or ilike(i.description, ^search_term)
        end
      else
        query
      end

    Repo.all(query)
  end

  def get_item(id) do
    Repo.get(Item, id)
  end

  def list_categories do
    Repo.all(from i in Item, select: i.category, distinct: true)
  end

  def reserve(id) do
    GenServer.cast(__MODULE__, {:reserve, id})
  end

  def mark_sold(id) do
    GenServer.cast(__MODULE__, {:update_item, id, %{status: "sold", reserved_until: nil}})
  end

  def mark_available(id) do
    GenServer.cast(__MODULE__, {:update_item, id, %{status: "available", reserved_until: nil}})
  end

  def update_item(id, updates) do
    GenServer.cast(__MODULE__, {:update_item, id, updates})
  end

  # --- Server Callbacks ---

  @impl true
  def init(_state) do
    # Process initial timers and expire outdated reservations
    # We use send_after so we don't block the startup querying the DB immediately
    # before Ecto is fully ready, wait we can query because we are after Repo in supervision tree
    send(self(), :startup_timers)
    {:ok, %{}}
  end

  @impl true
  def handle_info(:startup_timers, state) do
    now = System.system_time(:millisecond)
    
    reserved_items = 
      try do
        Repo.all(from i in Item, where: i.status == "reserved")
      rescue
        _e in Postgrex.Error -> []
      end

    Enum.each(reserved_items, fn item ->
      if item.reserved_until do
        if now >= item.reserved_until do
          item
          |> Item.changeset(%{status: "available", reserved_until: nil})
          |> Repo.update()
        else
          Process.send_after(self(), {:expire_reservation, item.id}, item.reserved_until - now)
        end
      end
    end)
    {:noreply, state}
  end

  @impl true
  def handle_info({:expire_reservation, id}, state) do
    if item = Repo.get(Item, id) do
      if item.status == "reserved" do
        Logger.info("Reservation expired for item #{id}")
        item
        |> Item.changeset(%{status: "available", reserved_until: nil})
        |> Repo.update()
      end
    end

    {:noreply, state}
  end

  @impl true
  def handle_cast({:reserve, id}, state) do
    case Repo.get(Item, id) do
      %Item{status: "available"} = item ->
        now = System.system_time(:millisecond)
        reserved_until = now + @reservation_time_ms

        case item |> Item.changeset(%{status: "reserved", reserved_until: reserved_until}) |> Repo.update() do
          {:ok, updated_item} ->
            Process.send_after(self(), {:expire_reservation, updated_item.id}, @reservation_time_ms)
          {:error, _} -> :ok
        end
      _ -> :ok
    end

    {:noreply, state}
  end

  @impl true
  def handle_cast({:update_item, id, updates}, state) do
    if item = Repo.get(Item, id) do
      updates_map = Enum.into(updates, %{}, fn {k, v} -> {to_string(k), v} end)
      
      updates_map = 
        if updates_map["status"] do
          if updates_map["status"] != "reserved" do
            Map.put(updates_map, "reserved_until", nil)
          else
            updates_map
          end
        else
          updates_map
        end

      Item.changeset(item, updates_map) |> Repo.update()
    end

    {:noreply, state}
  end
end
