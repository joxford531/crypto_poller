defmodule CryptoPoller.Jobs.FetchPoolHistory do
  use GenServer
  alias CryptoPoller.Pools
  alias CryptoPoller.Currencies

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    Process.send_after(__MODULE__, :fetch_history, 1_000)
    {:ok, nil}
  end

  @impl GenServer
  def handle_info(:fetch_history, state) do
    [pool_history, currency_history] =
      [
        Task.async(__MODULE__, :fetch_pool_history, []),
        Task.async(__MODULE__, :fetch_currency_history, [])
      ]
      |> Enum.map(fn task -> Task.await(task) end)

    Pools.bulk_create_pool_history(pool_history)
    Currencies.bulk_create_currency_history(currency_history)

    schedule_job()

    {:noreply, state}
  end

  def fetch_pool_history() do
    pools = Pools.get_all_pools()

    timestamp =
      DateTime.utc_now()
      |> DateTime.truncate(:second)

    Enum.map(pools, fn pool ->
      [hashrate, miner_count, worker_count] =
        [
          Task.async(
            __MODULE__,
            :make_request,
            [{pool.api.url <> pool.api.pool_hashrate, pool.api.hashrate_parser}]
          ),
          Task.async(
            __MODULE__,
            :make_request,
            [{pool.api.url <> pool.api.miner_count, pool.api.miner_count_parser}]
          ),
          Task.async(
            __MODULE__,
            :make_request,
            [{pool.api.url <> pool.api.worker_count, pool.api.worker_count_parser}]
          )
        ]
        |> Enum.map(fn task -> Task.await(task) end)
        |> List.flatten()

      %{
        timestamp: timestamp,
        pool_id: pool.id,
        currency_id: pool.currency_id,
        hashrate: hashrate,
        miner_count: miner_count,
        worker_count: worker_count
      }
    end)
  end

  def fetch_currency_history() do
    currency_apis = Currencies.get_apis()

    timestamp =
      DateTime.utc_now()
      |> DateTime.truncate(:second)

    Enum.map(currency_apis, fn api ->
      [usd_value, difficulty] = [
        Task.async(
          __MODULE__,
          :make_request,
          [{api.url <> api.usd_value, api.usd_value_parser}]
        ),
        Task.async(
          __MODULE__,
          :make_request,
          [{api.url <> api.difficulty, api.difficulty_parser}]
        )
      ]
      |> Enum.map(fn task -> Task.await(task) end)
      |> List.flatten()

      %{
        timestamp: timestamp,
        currency_id: api.currency_id,
        usd_value: usd_value,
        difficulty: difficulty
      }
    end)
  end

  def make_request({url, parser_fn}) do
    HTTPoison.get!(url)
    |> parse(parser_fn)
  end

  defp parse(data, parser) when is_function(parser) do
    parser.(data)
  end

  defp schedule_job() do
    Process.send_after(__MODULE__, :fetch_history, 60 * 2 * 1_000)
  end
end
