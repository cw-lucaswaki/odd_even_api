defmodule OddEvenApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :odd_even_api
  import Phoenix.Controller

  # Define the function before it's used
  defp exclude_ssl_redirect? do
    Application.compile_env(:odd_even_api, :ssl_redirect) == false
  end

  @session_options [
    store: :cookie,
    key: "_odd_even_api_key",
    signing_salt: "dnQS/ccO",
    same_site: "Lax"
  ]

  # socket "/live", Phoenix.LiveView.Socket,
  #   websocket: [connect_info: [session: @session_options]],
  #   longpoll: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :odd_even_api,
    gzip: false,
    only: OddEvenApiWeb.static_paths()

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId

  plug Plug.SSL,
  rewrite_on: [:x_forwarded_proto],
  host: Application.compile_env(:odd_even_api, :host),
  hsts: Application.compile_env(:odd_even_api, :env) != :test,
  exclude: fn -> Application.compile_env(:odd_even_api, :ssl_redirect) == false end

  plug :put_secure_browser_headers
  plug OddEvenApiWeb.PlugAttack
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug OddEvenApiWeb.Router
end
