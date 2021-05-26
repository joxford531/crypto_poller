defmodule CryptoPoller.Pools.History do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "pool_history" do
    field :timestamp, :utc_datetime
    field :hashrate, :integer
    field :miner_count, :integer
    field :worker_count, :integer
    belongs_to :pool, CryptoPoller.Pools.Pool
    belongs_to :currency, CryptoPoller.Currencies.Currency
  end

  def changeset(pool, params \\ %{}) do
    pool
    |> cast(params, [:timestamp, :hashrate, :miner_count, :worker_count, :pool_id, :currency_id])
    |> validate_required([:timestamp, :hashrate, :miner_count, :worker_count, :pool_id, :currency_id])
    |> assoc_constraint(:pool)
    |> assoc_constraint(:currency)
  end
end
