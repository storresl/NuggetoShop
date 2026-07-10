defmodule NuggetoShop.Repo.Migrations.ResetItemsSequence do
  use Ecto.Migration

  def up do
    execute("SELECT setval('items_id_seq', (SELECT MAX(id) FROM items))")
  end

  def down do
  end
end
