defmodule CryptoPoller.Repo.Migrations.CurrencyHistory do
  use Ecto.Migration

  def change do
    create table(:pool_history, primary_key: false) do
      add :timestamp, :utc_datetime, primary_key: true
      add :hashrate, :bigserial
      add :miner_count, :integer
      add :worker_count, :integer
      add :pool_id, references(:pools), primary_key: true
      add :currency_id, references(:currencies), primary_key: true
    end

    create table(:currency_history, primary_key: false) do
      add :timestamp, :utc_datetime, primary_key: true
      add :usd_value, :float
      add :difficulty, :bigserial
      add :currency_id, references(:currencies), primary_key: true
    end
  end
end
