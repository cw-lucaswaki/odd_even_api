# File: api_attack.exs

defmodule ApiAttack do
  require Logger

  def run do
    Logger.info("[ApiAttack] Starting API attack", module: __MODULE__, function: "run/0")
    base_url = System.get_env("URL", "http://localhost:4000/api/check/")
    num_requests = System.get_env("NUM_REQUESTS", "1000") |> String.to_integer()
    concurrency = System.get_env("CONCURRENCY", "100") |> String.to_integer()

    IO.puts("Starting attack on #{base_url}")
    IO.puts("Sending #{num_requests} requests with concurrency of #{concurrency}")

    start_time = System.monotonic_time(:millisecond)

    1..num_requests
    |> Task.async_stream(
      fn _ ->
        # Generate random number between 0 and 999
        random_number = :rand.uniform(100_000) - 1
        url = base_url <> Integer.to_string(random_number)
        send_request(url)
      end,
      max_concurrency: concurrency,
      ordered: false
    )
    |> Enum.reduce(%{total: 0, success: 0, error: 0}, fn
      {:ok, :ok}, acc -> %{acc | total: acc.total + 1, success: acc.success + 1}
      {:ok, :error}, acc -> %{acc | total: acc.total + 1, error: acc.error + 1}
    end)
    |> report_results(start_time)
  end

  defp send_request(url) do
    case :httpc.request(:get, {String.to_charlist(url), []}, [], []) do
      {:ok, {{_, 200, _}, _, _}} -> :ok
      _ -> :error
    end
  end

  defp report_results(results, start_time) do
    Logger.info("[ApiAttack] Attack completed", module: __MODULE__, function: "report_results/2")
    end_time = System.monotonic_time(:millisecond)
    duration = (end_time - start_time) / 1000

    IO.puts("\nAttack completed in #{duration} seconds")
    IO.puts("Total requests: #{results.total}")
    IO.puts("Successful requests: #{results.success}")
    IO.puts("Failed requests: #{results.error}")
    IO.puts("Requests per second: #{results.total / duration}")
  end
end

# Ensure inets is started
:inets.start()

# Run the attack
ApiAttack.run()
