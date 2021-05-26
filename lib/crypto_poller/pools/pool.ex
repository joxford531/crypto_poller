defmodule CryptoPoller.Pools.Pool do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pools" do
    field :name, :string
    belongs_to :currency, CryptoPoller.Currencies.Currency
    has_one :api, CryptoPoller.Pools.Api
    timestamps()
  end

  def changeset(pool, params \\ %{}) do
    pool
    |> cast(params, [:name, :currency_id])
    |> validate_required([:name, :currency_id])
    |> assoc_constraint(:currency)
  end
end
