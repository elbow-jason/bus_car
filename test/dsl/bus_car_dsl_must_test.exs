defmodule BusCarDslMustTest do
  use ExUnit.Case
  doctest BusCar.Dsl.Must
  alias BusCar.Dsl.Must

  test "must_not list" do
    result = Must.parse([:must, :term, "name", 34], [])
    expected = [%{term: %{"name" => %{value: 34}}}]
    assert result == {[], expected}
  end

  test "query bool must ... " do
    result = BusCar.Dsl.parse([:query, :bool, :must, :term, "name", 34])
    expected = %{query: %{bool: %{must: [%{term: %{"name" => %{value: 34}}}]}}}
    assert result == expected
  end

end
