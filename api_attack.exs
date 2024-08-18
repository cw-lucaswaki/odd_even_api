# File: api_attack.exs

defmodule ApiAttack do
  require Logger

  def run do
    Logger.info("[ApiAttack] Starting API attack", module: __MODULE__, function: "run/0")
    base_url = System.get_env("URL", "http://localhost:4000/api/check/")
    num_requests = System.get_env("NUM_REQUESTS", "1000") |> String.to_integer()
    concurrency = System.get_env("CONCURRENCY", "10") |> String.to_integer()
    delay = System.get_env("DELAY", "100") |> String.to_integer()

    IO.puts("Starting attack on #{base_url}")
    IO.puts("Sending #{num_requests} requests with concurrency of #{concurrency}")
    IO.puts("Delay between requests: #{delay}ms")

    start_time = System.monotonic_time(:millisecond)

    results =
      1..num_requests
      |> Task.async_stream(
        fn _ ->
          # Add delay between requests
          Process.sleep(delay)
          random_number = :rand.uniform(100_000) - 1
          url = base_url <> Integer.to_string(random_number)
          send_request(url)
        end,
        max_concurrency: concurrency,
        ordered: false
      )
      |> Enum.reduce(%{total: 0, success: 0, error: 0, rate_limited: 0}, fn
        {:ok, {:ok, 200}}, acc ->
          %{acc | total: acc.total + 1, success: acc.success + 1}

        {:ok, {:ok, 429}}, acc ->
          %{acc | total: acc.total + 1, rate_limited: acc.rate_limited + 1}

        {:ok, _}, acc ->
          %{acc | total: acc.total + 1, error: acc.error + 1}
      end)

    report_results(results, start_time)
  end

  defp send_request(url) do
    case :httpc.request(:get, {String.to_charlist(url), []}, [], []) do
      {:ok, {{_, status_code, _}, _, _}} -> {:ok, status_code}
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
    IO.puts("Rate limited requests: #{results.rate_limited}")
    IO.puts("Failed requests: #{results.error}")
    IO.puts("Requests per second: #{results.total / duration}")
  end
end

# Ensure inets is started
:inets.start()

# Run the attack
ApiAttack.run()
