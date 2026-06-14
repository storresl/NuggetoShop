defmodule NuggetoShop.Release do
  @app :nuggeto_shop

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def seed do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, fn _repo ->
        json_path = Application.app_dir(:nuggeto_shop, "priv/data/items.json")
        seed_script = Application.app_dir(:nuggeto_shop, "priv/repo/seeds.exs")

        if File.exists?(json_path) do
          Code.eval_file(seed_script)
        end
      end)
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
