defmodule OddEvenApiWeb.PlugAttack do
  @moduledoc """
  Defines rate limiting rules for the OddEvenApi application.

  This module uses PlugAttack to implement throttling based on IP address,
  helping to prevent abuse and ensure fair usage of the API.
  """

  use PlugAttack

  rule "throttle by ip", conn do
    throttle(conn.remote_ip,
      period: 60_000,
      limit: 180,  # Allow 120 requests per minute (2 per second on average)
      storage: {PlugAttack.Storage.Ets, OddEvenApi.PlugAttack.Storage}
    )
  end

  def allow_action(conn, _data, _opts) do
    conn
  end

  def block_action(conn, _data, _opts) do
    conn
    |> Plug.Conn.put_status(429)
    |> Phoenix.Controller.json(%{error: "Rate limit exceeded"})
    |> Plug.Conn.halt()
  end
end
