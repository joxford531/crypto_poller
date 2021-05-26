defmodule CryptoPoller.Repo.Migrations.InitBaseTables do
  use Ecto.Migration

  def change do
    create table(:currencies) do
      add :name, :string

      timestamps()
    end

    create table(:pools) do
      add :name, :string
      add :currency_id, references(:currencies)

      timestamps()
    end

    create table(:pool_api, primary_key: false) do
      add :url, :string
      add :pool_hashrate, :string
      add :miner_count, :string
      add :worker_count, :string
      add :hashrate_parser, :binary
      add :miner_count_parser, :binary
      add :worker_count_parser, :binary
      add :pool_id, references(:pools),  primary_key: true

      timestamps()
    end

    create table(:currency_api, primary_key: false) do
      add :url, :string
      add :usd_value, :string
      add :difficulty, :string
      add :usd_value_parser, :binary
      add :difficulty_parser, :binary
      add :currency_id, references(:currencies), primary_key: true

      timestamps()
    end
  end
end
