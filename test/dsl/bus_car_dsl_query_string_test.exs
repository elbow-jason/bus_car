defmodule BusCarDslQueryStringTest do
  use ExUnit.Case
  doctest BusCar.Dsl.QueryString
  alias BusCar.Dsl.QueryString

  test "query_string map" do
    result = QueryString.parse([:query_string, ".jason"], %{})
    assert result == {[],  %{query_string: %{query: ".jason"}}}
  end

  # test "regexp list" do
  #   result = QueryString.parse([:query_string, "name", ".json"], [])
  #   assert result == {[], [%{query_string: %{"name" => %{value: ".json"}}}]}
  # end
end
