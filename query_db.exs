alias NuggetoShop.Repo
alias NuggetoShop.Catalog.Item
import Ecto.Query

items = Repo.all(from i in Item, order_by: [desc: i.id], limit: 20)
Enum.each(items, fn i -> IO.puts("#{i.id} - #{i.name} - #{inspect(i.image)}") end)
