defmodule CryptoPoller.Currencies.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  schema "currencies" do
    field :name, :string
    has_one :api, CryptoPoller.Currencies.Api
    timestamps()
  end

  def changeset(currency, params \\ %{}) do
    currency
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
