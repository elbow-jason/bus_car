defmodule BusCarDslFuzzyTest do
  use ExUnit.Case
  doctest BusCar.Dsl.Fuzzy
  alias BusCar.Dsl.Fuzzy

  test "fuzzy map" do
    result = Fuzzy.parse([:fuzzy, "name", "jason"], %{})
    assert result == {[], %{fuzzy: %{"name" => %{value: "jason"}}}}
  end

  test "fuzzy list" do
    result = Fuzzy.parse([:fuzzy, "name", "json"], [])
    assert result == {[], [%{fuzzy: %{"name" => %{value: "json"}}}]}
  end

end
