defmodule BusCarDslExistsTest do
  use ExUnit.Case
  doctest BusCar.Dsl.Exists
  alias BusCar.Dsl.Exists

  test "exists map" do
    result = Exists.parse([:exists, :field, "name"], %{})
    expected_map = %{:exists => %{:field => "name"}}
    assert result == {[], expected_map}
  end

  test "exists list" do
    result = Exists.parse([:exists, :field, "name"], [])
    expected_list = [%{:exists => %{:field => "name"}}]
    assert result == {[], expected_list}
  end

end
