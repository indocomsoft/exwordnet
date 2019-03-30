defmodule ExwordnetTest do
  use ExUnit.Case
  doctest Exwordnet

  test "greets the world" do
    assert Exwordnet.hello() == :world
  end
end
