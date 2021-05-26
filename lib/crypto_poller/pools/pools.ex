defmodule CryptoPoller.Pools do
  import Ecto.Query, warn: false
  alias CryptoPoller.Pools.{Api, History, Pool}
  alias CryptoPoller.Currencies.Currency
  alias CryptoPoller.Repo

  def create_pool(attrs) do
    %Pool{}
    |> Pool.changeset(attrs)
    |> Repo.insert()
  end

  def create_pool_by_currency(%Currency{} = currency, attrs) do
    struct(Pool, attrs)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:currency, currency)
    |> Repo.insert!()
  end

  def get_all_pools() do
    Repo.all(
      from p in Pool,
      join: a in Api, on: a.pool_id == p.id,
      preload: [:api],
      order_by: p.id
    )
  end

  def get_pools_by_currency(currency_id) do
    Repo.all(
      from p in Pool,
      where: p.currency_id == ^currency_id,
      order_by: p.id
    )
  end

  def get_pool_by_name_and_currency_name(pool_name, currency_name) do
    Repo.one(
      from p in Pool,
      join: c in Currency, on: c.id == p.currency_id,
      where: p.name == ^pool_name and c.name == ^currency_name,
      preload: [:currency],
      order_by: p.id
    )
  end

  def get_api_by_pool_id(pool_id) do
    Repo.one(
      from a in Api,
      where: a.pool_id == ^pool_id
    )
  end

  def get_history_between(start_time, end_time) do
    Repo.all(
      from h in History,
      where: h.timestamp >= ^start_time and h.time < ^end_time,
      order_by: [asc: h.timestamp]
    )
  end

  def create_api(attrs) do
    %CryptoPoller.Pools.Api{}
    |> CryptoPoller.Pools.Api.changeset(attrs)
    |> Repo.insert()
  end

  def create_api_by_pool(%Pool{} = pool, attrs) do
    struct(Api, attrs)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:pool, pool)
    |> Repo.insert!()
  end

  def update_api(%Api{} = api, attrs) do
    api
    |> Api.changeset(attrs)
    |> Repo.update()
  end

  def bulk_create_pool_history(histories) when is_list(histories) do
    Repo.insert_all(History, histories)
  end
end
