defmodule OddEvenApiWeb.NumberController do
  use OddEvenApiWeb, :controller

  def check(conn, %{"number" => number}) do
    case Integer.parse(number) do
      {int, _} ->
        result = if rem(int, 2) == 0, do: "even", else: "odd"
        json(conn, %{number: int, result: result})
      :error ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid number provided"})
    end
  end
end
