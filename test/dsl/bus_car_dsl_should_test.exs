defmodule BusCarDslShouldTest do
  use ExUnit.Case
  doctest BusCar.Dsl.Should
  alias BusCar.Dsl.Should

  test "should list" do
    result = Should.parse([:should, :term, "name", 34], [])
    expected = [%{term: %{"name" => %{value: 34}}}]
    assert result == {[], expected}
  end

  test "query bool should ... " do
    result = BusCar.Dsl.parse([:query, :bool, :should, :term, "name", 34])
    expected = %{query: %{bool: %{should: [%{term: %{"name" => %{value: 34}}}]}}}
    assert result == expected
  end

end
