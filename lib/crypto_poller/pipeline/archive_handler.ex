defmodule CryptoPoller.Pipeline.ArchiveHandler do
  use GenStage
  use Timex
  alias ExAws.S3

  @write_path "./persist"

  def start_link(_args) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    {:consumer, :ok, subscribe_to: [{CryptoPoller.Pipeline.ArchiveProducer, max_demand: 1}]}
  end

  def handle_events([date], _from, state) do
    start = Timex.to_datetime(date, "America/New_York")
    finish =
      Date.add(date, 1)
      |> Timex.to_datetime("America/New_York")

    write_pool_history_csv(start, finish)
    write_currency_history_csv(start, finish)

    {:noreply, [], state}
  end

  defp write_pool_history_csv(start, finish) do
    rows = CryptoPoller.Pools.get_history_between(start, finish)

    formatted_results = Enum.map(rows, fn row ->
      "#{row.timestamp},#{row.hashrate},#{row.miner_count},#{row.worker_count},#{row.pool_id},#{row.currency_id}" end)

    formatted_results =
      ["Timestamp, Hashrate, Miner Count, Worker Count, Pool_Id, Currency_Id" | formatted_results]

    {:ok, date} = Timex.format(start, "%Y-%m-%d", :strftime)

    path = @write_path <> "/" <> date <> ".csv"

    if File.exists?(@write_path) == false do
      File.mkdir!(@write_path)
    end

    File.write!(path, Enum.join(formatted_results, "\r\n"), [:utf8])

    upload_s3(path, "pool_history", date)
  end

  defp write_currency_history_csv(start, finish) do
    rows = CryptoPoller.Pools.get_history_between(start, finish)

    formatted_results = Enum.map(rows, fn row ->
      "#{row.timestamp},#{row.usd_value},#{row.difficulty},#{row.currency_id}" end)

    formatted_results =
      ["Timestamp, USD Value, Difficulty, Currency_Id" | formatted_results]

    {:ok, date} = Timex.format(start, "%Y-%m-%d", :strftime)

    path = @write_path <> "/" <> date <> ".csv"

    if File.exists?(@write_path) == false do
      File.mkdir!(@write_path)
    end

    File.write!(path, Enum.join(formatted_results, "\r\n"), [:utf8])

    upload_s3(path, "currency_history", date)
  end

  defp upload_s3(path, folder, date) do
    [year, month, _day] = String.split(date, "-")

    {:ok, _result} =
      path |>
      S3.Upload.stream_file |>
      S3.upload("personal-joxford", "crypto_history/#{folder}/#{year}/#{month}/#{date}.csv") |>
      ExAws.request

    File.rm!(path)
  end
end
