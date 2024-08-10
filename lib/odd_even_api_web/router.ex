defmodule OddEvenApiWeb.Router do
  use OddEvenApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", OddEvenApiWeb do
    pipe_through :api

    get "/check/:number", NumberController, :check
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:odd_even_api, :dev_routes) do

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
