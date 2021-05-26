defmodule CryptoPoller.Currencies do
  import Ecto.Query, warn: false
  alias CryptoPoller.Currencies.{Api, Currency, History}
  alias CryptoPoller.Repo

  def create_currency(attrs) do
    %Currency{}
    |> Currency.changeset(attrs)
    |> Repo.insert()
  end

  def get_currencies() do
    Repo.all(
      from c in Currency,
      order_by: c.id
    )
  end

  def get_apis() do
    Repo.all(
      from a in Api
    )
  end

  def get_api_by_currency_id(currency_id) do
    Repo.one(
      from a in Api,
      where: a.currency_id == ^currency_id
    )
  end

  def get_currency_by_name(name) do
    Repo.one(
      from c in Currency,
      where: c.name == ^name,
      order_by: c.id
    )
  end

  def get_history_between(start_time, end_time) do
    Repo.all(
      from h in History,
      where: h.timestamp >= ^start_time and h.time < ^end_time,
      order_by: [asc: h.timestamp]
    )
  end

  def bulk_create_currency_history(histories) when is_list(histories) do
    Repo.insert_all(History, histories)
  end

  def create_api(attrs) do
    %CryptoPoller.Currencies.Api{}
    |> CryptoPoller.Currencies.Api.changeset(attrs)
    |> Repo.insert()
  end

  def create_api_by_currency(%Currency{} = currency, attrs) do
    struct(Api, attrs)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:currency, currency)
    |> Repo.insert!()
  end

  def update_api(%Api{} = api, attrs) do
    api
    |> Api.changeset(attrs)
    |> Repo.update()
  end
end
