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
      limit: 100,
      storage: {PlugAttack.Storage.Ets, OddEvenApi.PlugAttack.Storage}
    )
  end
end
