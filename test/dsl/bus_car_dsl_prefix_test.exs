defmodule BusCarDslPrefixTest do
  use ExUnit.Case
  doctest BusCar.Dsl.Prefix
  alias BusCar.Dsl.Prefix

  test "prefix map" do
    result = Prefix.parse([:prefix, "name", "s"], %{})
    assert result == {[], %{prefix: %{"name" => %{value: "s"}}}}
  end

  test "prefix list" do
    result = Prefix.parse([:prefix, "name", "s"], [])
    assert result == {[], [%{prefix: %{"name" => %{value: "s"}}}]}
  end

end
