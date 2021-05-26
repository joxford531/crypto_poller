defmodule CryptoPollerTest do
  use ExUnit.Case
  doctest CryptoPoller

  test "greets the world" do
    assert CryptoPoller.hello() == :world
  end
end
