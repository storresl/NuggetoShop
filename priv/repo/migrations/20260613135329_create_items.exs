defmodule NuggetoShop.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string, null: false
      add :category, :string, null: false
      add :description, :text
      add :image, :string
      add :price, :string
      add :reference_price, :string
      add :status, :string, default: "available"
      add :reserved_until, :bigint

      timestamps()
    end
  end
end
