defmodule ApiAttack do
  use Application

  def start(_type, _args) do
    {num_requests, _} = System.get_env("NUM_REQUESTS", "1000") |> Integer.parse()
    {concurrency, _} = System.get_env("CONCURRENCY", "100") |> Integer.parse()
    url = System.get_env("URL", "http://localhost:4000/api/check/42")

    IO.puts("Starting attack on #{url}")
    IO.puts("Sending #{num_requests} requests with concurrency of #{concurrency}")

    children = [
      {Task.Supervisor, name: ApiAttack.TaskSupervisor},
      {ApiAttack.Attacker, {url, num_requests, concurrency}}
    ]

    opts = [strategy: :one_for_one, name: ApiAttack.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule ApiAttack.Attacker do
  use GenServer

  def start_link({url, num_requests, concurrency}) do
    GenServer.start_link(__MODULE__, {url, num_requests, concurrency})
  end

  def init(state) do
    Process.send_after(self(), :attack, 0)
    {:ok, state}
  end

  def handle_info(:attack, {url, num_requests, concurrency}) do
    start_time = System.monotonic_time(:millisecond)

    task_stream =
      Task.Supervisor.async_stream_nolink(
        ApiAttack.TaskSupervisor,
        1..num_requests,
        fn _ -> send_request(url) end,
        max_concurrency: concurrency,
        ordered: false
      )

    results =
      task_stream
      |> Enum.reduce(%{total: 0, success: 0, error: 0}, fn
        {:ok, :ok}, acc -> %{acc | total: acc.total + 1, success: acc.success + 1}
        {:ok, :error}, acc -> %{acc | total: acc.total + 1, error: acc.error + 1}
        {:exit, _}, acc -> %{acc | total: acc.total + 1, error: acc.error + 1}
      end)

    end_time = System.monotonic_time(:millisecond)
    duration = (end_time - start_time) / 1000

    IO.puts("\nAttack completed in #{duration} seconds")
    IO.puts("Total requests: #{results.total}")
    IO.puts("Successful requests: #{results.success}")
    IO.puts("Failed requests: #{results.error}")
    IO.puts("Requests per second: #{results.total / duration}")

    {:stop, :normal, {url, num_requests, concurrency}}
  end

  defp send_request(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200}} -> :ok
      _ -> :error
    end
  end
end
