defmodule OddEvenApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OddEvenApiWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:odd_even_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: OddEvenApi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: OddEvenApi.Finch},
      # Start a worker by calling: OddEvenApi.Worker.start_link(arg)
      # {OddEvenApi.Worker, arg},
      # Start to serve requests, typically the last entry
      OddEvenApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OddEvenApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OddEvenApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
