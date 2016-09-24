defmodule BusCarDslMatchTest do
  use ExUnit.Case
  doctest BusCar.Dsl.Match
  alias BusCar.Dsl.Match

  test "match map" do
    result = Match.parse([:match, "name", "jason"], %{})
    assert result == {[], %{match: %{"name" => %{query: "jason"}}}}
  end

  test "match list" do
    result = Match.parse([:match, "name", "json"], [])
    assert result == {[], [%{match: %{"name" => %{query: "json"}}}]}
  end
end
