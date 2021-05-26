defmodule CryptoPoller.Currencies.Api do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "currency_api" do
    field :url, :string
    field :usd_value, :string
    field :difficulty, :string
    field :usd_value_parser, CryptoPoller.ErlangETF
    field :difficulty_parser, CryptoPoller.ErlangETF
    belongs_to :currency, CryptoPoller.Currencies.Currency, primary_key: true
    timestamps()
  end

  def changeset(pool, params \\ %{}) do
    pool
    |> cast(params,
      [
        :url,
        :usd_value,
        :difficulty,
        :usd_value_parser,
        :difficulty_parser,
        :currency_id
      ])
    |> validate_required(
      [
        :url,
        :usd_value,
        :difficulty,
        :usd_value_parser,
        :difficulty_parser,
        :currency_id
      ])
    |> assoc_constraint(:currency)
  end
end
