defmodule OddEvenApiWeb.NumberController do
  use OddEvenApiWeb, :controller
  require Logger

  def check(conn, %{"number" => number}) do
    case Integer.parse(number) do
      {int_number, ""} when is_integer(int_number) ->
        result = if rem(int_number, 2) == 0, do: "even", else: "odd"
        json(conn, %{number: int_number, result: result})

      _ ->
        log_security_event(conn, "Invalid input attempt")

        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid input. Please provide a valid integer."})
    end
  end

  defp log_security_event(conn, event) do
    Logger.warning("Security event: #{event}",
      remote_ip: to_string(:inet.ntoa(conn.remote_ip)),
      request_path: conn.request_path
    )
  end
end
