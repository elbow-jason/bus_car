defmodule BusCarDslNestedTest do
  use ExUnit.Case
  doctest BusCar.Dsl.Nested
  alias BusCar.Dsl.Nested

  test "nested needs path" do
    dsl = [:nested, :path, "category", :query, :bool, :must, :match, "name", "jules"]
    result = Nested.parse(dsl, %{})
    assert result == {[], %{
      nested: %{
        path: "category",
        query: %{
          bool: %{
            must: [
              %{match: %{"name" => %{query: "jules"}}}
            ]
          }
        }
      }
    }}
  end

end
