defmodule CryptoPoller.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      CryptoPoller.Repo,
      CryptoPoller.Pipeline.ArchiveProducer,
      CryptoPoller.Pipeline.ArchiveHandler,
      CryptoPoller.Jobs.FetchPoolHistory,
      CryptoPoller.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CryptoPoller.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
