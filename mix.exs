defmodule CryptoPoller.MixProject do
  use Mix.Project

  def project do
    [
      app: :crypto_poller,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {CryptoPoller.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.1.6"},
      {:postgrex, "~> 0.14.1"},
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.8"},
      {:hackney, "~> 1.17"},
      {:timex, "~> 3.6"},
      {:sweet_xml, "~> 0.6"},
      {:quantum, "~> 2.3"},
      {:gen_stage, "~> 0.14"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"}
    ]
  end
end
