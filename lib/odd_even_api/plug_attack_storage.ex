defmodule OddEvenApi.PlugAttackStorage do
  @moduledoc """
  Initializes and manages the PlugAttack ETS storage.
  """

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    :ets.new(OddEvenApi.PlugAttack.Storage, [:named_table, :public, :set])
    {:ok, %{}}
  end
end
