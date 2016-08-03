defmodule Bezoar.Router do
  use Bezoar.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    
    resources "/players", PlayerController, except: [:new, :edit]
  end

  scope "/", Bezoar do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Bezoar do
  #   pipe_through :api
  # end
end
