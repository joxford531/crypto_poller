defmodule CryptoPoller.Currencies.History do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "currency_history" do
    field :timestamp, :utc_datetime
    field :usd_value, :float
    field :difficulty, :integer
    belongs_to :currency, CryptoPoller.Currencies.Currency
  end

  def changeset(pool, params \\ %{}) do
    pool
    |> cast(params, [:timestamp, :usd_value, :difficulty, :currency_id])
    |> validate_required([:timestamp, :usd_value, :difficulty, :currency_id])
    |> assoc_constraint(:currency)
  end
end
