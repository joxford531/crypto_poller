use Mix.Config

config :crypto_poller, CryptoPoller.Repo,
  database: System.get_env("DB_DATABASE") || "Mining",
  username: System.get_env("DB_USER") || "postgres",
  password: System.get_env("DB_PW") || "postgres",
  hostname: System.get_env("DB_HOST") || "localhost",
  port: System.get_env("DB_PORT") || "5432"

config :crypto_poller, ecto_repos: [CryptoPoller.Repo]

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role]

config :ex_aws,
  json_codec: Jason

config :weather_db, CryptoPoller.Scheduler,
  timezone: "America/New_York",
  jobs: [
    # Every 5AM Eastern
    {"0 5 * * *", {CryptoPoller.Jobs.Archive, :start_archive, []}},
  ]
