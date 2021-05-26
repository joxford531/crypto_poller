defmodule CryptoPoller.Jobs.Archive do

  def start_archive() do
    yesterday = Date.add(Date.utc_today(), -1)
    CryptoPoller.Pipeline.ArchiveProducer.archive_date(yesterday)
  end
end
