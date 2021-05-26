defmodule CryptoPoller.Repo do
  use Ecto.Repo,
    otp_app: :crypto_poller,
    adapter: Ecto.Adapters.Postgres
end

defmodule CryptoPoller.ErlangETF do
  def type, do: :binary

  def cast(binary = << 131, _ :: binary >>) do
    try do
      {:ok, :erlang.binary_to_term(binary)}
    catch
      _ -> {:ok, binary}
    end
  end

  def cast(any), do: {:ok, any}

  def load(any), do: cast(any)

  def dump(any), do: {:ok, :erlang.term_to_binary(any)}
end
