defmodule NuggetoShop.Repo.Migrations.ChangeImageToText do
  use Ecto.Migration

  def change do
    alter table(:items) do
      modify :image, :text
    end
  end
end
