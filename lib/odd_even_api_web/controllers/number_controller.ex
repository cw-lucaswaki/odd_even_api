defmodule OddEvenApiWeb.NumberController do
  use OddEvenApiWeb, :controller
  require Logger

  def check(conn, %{"number" => number_string}) do
    Logger.info("[NumberController] Checking number: #{number_string}",
      module: __MODULE__,
      function: "check/2"
    )

    case Integer.parse(number_string) do
      {number, ""} ->
        result = if rem(number, 2) == 0, do: "even", else: "odd"

        Logger.info("[NumberController] Result: #{result}",
          module: __MODULE__,
          function: "check/2"
        )

        json(conn, %{number: number, result: result})

      _ ->
        Logger.warn("[NumberController] Invalid number provided: #{number_string}",
          module: __MODULE__,
          function: "check/2"
        )

        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid number provided"})
    end
  end
end
