defmodule NuggetoShopWeb.Router do
  use NuggetoShopWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {NuggetoShopWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug :browser
    plug :require_admin
  end

  defp require_admin(conn, _opts) do
    password = Application.fetch_env!(:nuggeto_shop, :admin_password)
    Plug.BasicAuth.basic_auth(conn, username: "admin", password: password)
  end

  scope "/", NuggetoShopWeb do
    pipe_through :browser

    get "/", PageController, :home
    post "/reserve/:id", PageController, :reserve
  end

  scope "/admin", NuggetoShopWeb do
    pipe_through :admin

    get "/", AdminController, :index
    get "/new", AdminController, :new
    post "/new", AdminController, :create
    post "/status/:id", AdminController, :update_status
    get "/edit/:id", AdminController, :edit
    post "/edit/:id", AdminController, :update
    post "/delete/:id", AdminController, :delete
  end
end
