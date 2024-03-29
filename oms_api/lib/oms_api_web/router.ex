defmodule OmsApiWeb.Router do
  use OmsApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OmsApiWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/", OmsApiWeb do
    pipe_through :api

    resources "/instances", InstanceController, only: [] do
      resources "/metrics", MetricController, only: [:index]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", OmsApiWeb do
  #   pipe_through :api
  # end
end
