defmodule CryptoPoller.Pools.Api do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "pool_api" do
    field :url, :string
    field :pool_hashrate, :string
    field :miner_count, :string
    field :worker_count, :string
    field :hashrate_parser, CryptoPoller.ErlangETF
    field :miner_count_parser, CryptoPoller.ErlangETF
    field :worker_count_parser, CryptoPoller.ErlangETF
    belongs_to :pool, CryptoPoller.Pools.Pool, primary_key: true
    timestamps()
  end

  def changeset(pool, params \\ %{}) do
    pool
    |> cast(params,
      [
        :url,
        :pool_hashrate,
        :miner_count,
        :worker_count,
        :hashrate_parser,
        :miner_count_parser,
        :worker_count_parser,
        :pool_id
      ])
    |> validate_required(
      [
        :url,
        :pool_hashrate,
        :miner_count,
        :worker_count,
        :hashrate_parser,
        :miner_count_parser,
        :worker_count_parser,
        :pool_id
      ])
    |> assoc_constraint(:pool)
  end
end
