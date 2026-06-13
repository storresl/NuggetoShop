defmodule NuggetoShop.Catalog.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :category, :description, :image, :price, :reference_price, :status, :reserved_until]}
  schema "items" do
    field :name, :string
    field :category, :string
    field :description, :string
    field :image, :string
    field :price, :string
    field :reference_price, :string
    field :status, :string, default: "available"
    field :reserved_until, :integer

    timestamps()
  end

  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :category, :description, :image, :price, :reference_price, :status, :reserved_until])
    |> validate_required([:name, :category, :price])
  end
end
