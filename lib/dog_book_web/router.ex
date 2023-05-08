defmodule DogBookWeb.Router do
  use DogBookWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DogBookWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DogBookWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/admin", DogBookWeb do
    pipe_through :browser

    live "/breeds", BreedLive.Index, :index
    live "/breeds/new", BreedLive.Index, :new
    live "/breeds/:id/edit", BreedLive.Index, :edit

    live "/breeds/:id", BreedLive.Show, :show
    live "/breeds/:id/show/edit", BreedLive.Show, :edit

    live "/persons", PersonLive.Index, :index
    live "/persons/new", PersonLive.Index, :new
    live "/persons/:id/edit", PersonLive.Index, :edit

    live "/persons/:id", PersonLive.Show, :show
    live "/persons/:id/show/edit", PersonLive.Show, :edit

    live "/breeders", BreederLive.Index, :index
    live "/breeders/new", BreederLive.Index, :new
    live "/breeders/:id/edit", BreederLive.Index, :edit

    live "/breeders/:id", BreederLive.Show, :show
    live "/breeders/:id/show/edit", BreederLive.Show, :edit

    live "/champions", ChampionLive.Index, :index
    live "/champions/new", ChampionLive.Index, :new
    live "/champions/:id/edit", ChampionLive.Index, :edit

    live "/champions/:id", ChampionLive.Show, :show
    live "/champions/:id/show/edit", ChampionLive.Show, :edit

    live "/colors", ColorLive.Index, :index
    live "/colors/new", ColorLive.Index, :new
    live "/colors/:id/edit", ColorLive.Index, :edit

    live "/colors/:id", ColorLive.Show, :show
    live "/colors/:id/show/edit", ColorLive.Show, :edit

    live "/dogs", DogLive.Index, :index
    live "/dogs/new", DogLive.Index, :new
    live "/dogs/:id/edit", DogLive.Index, :edit

    live "/dogs/:id", DogLive.Show, :show
    live "/dogs/:id/show/edit", DogLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", DogBookWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:dog_book, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DogBookWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
