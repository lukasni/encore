defmodule EncoreWeb.Router do
  use EncoreWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {EncoreWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug EncoreWeb.Plugs.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EncoreWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/apply", RecruitmentController, :apply
    get "/recruitment", RecruitmentController, :index
    get "/my_application", RecruitmentController, :my_application
    get "/my_application/questionnaire", RecruitmentController, :questionnaire
    get "/my_application/characters", RecruitmentController, :characters
    get "/auth/evesso/callback", AuthController, :callback
    get "/dashboard", PageController, :dashboard
  end

  scope "/auth", EncoreWeb do
    pipe_through :browser

    get "/login", AuthController, :login
    get "/grant", AuthController, :grant_scopes
    get "/auth/evesso/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", EncoreWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/live_dashboard", metrics: EncoreWeb.Telemetry, ecto_repos: [Encore.Repo]
    end
  end
end
