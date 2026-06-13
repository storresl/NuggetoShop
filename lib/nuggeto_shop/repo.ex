defmodule NuggetoShop.Repo do
  use Ecto.Repo,
    otp_app: :nuggeto_shop,
    adapter: Ecto.Adapters.Postgres
end
