defmodule BusCarDslTest do
  use ExUnit.Case

  test "multi bool" do
    assert BusCarDsl.parse([
      :query, :bool,
        :must,      :term,  :age,         33,
        :must_not,  :match, :name,        "beef",
        :should,    :match, :first_name,  "Jason",
        :filter,    :term,  :last_name,   "gold",
    ]) == %{
      query: %{
        bool: %{
          must: [
            %{term: %{age: %{value: 33}}}
          ],
          must_not: [
            %{match: %{name: %{query: "beef"}}}
          ],
          should: [
            %{match: %{first_name: %{query: "Jason"}}}
          ],
          filter: [
            %{term: %{last_name: %{value: "gold"}}}
          ],
        }
      }
    }
  end



  test "tirex example" do
    assert BusCarDsl.parse([
        :query, :nested, :path, "comments",
          :query, :bool, :must,
            :match, "comments.message", "cool",
            :match, "comments.author",  "John",
    ]) == %{
      query: %{
        nested: %{
          path: "comments",
          query: %{
            bool: %{
              must: [
                %{match: %{"comments.author"  => %{query: "John"}}},
                %{match: %{"comments.message" => %{query: "cool"}}},
              ]
            }
          }
        }
      }
    }
  end

  test "query bool must match <field> <term>" do
    expected = %{
      query: %{
        bool: %{
          must: [
            %{
              match: %{
                "field" => %{
                  query: "term"
                }
              }
            }
          ]
        }
      }
    }
    assert BusCarDsl.parse([:query, :bool, :must, :match, "field", "term"]) == expected
  end

  test "query match _all <value>" do
    expected = %{
      query: %{
        match: %{
          _all: "value"
        }
      }
    }
    assert BusCarDsl.parse([:query, :match, :_all, "value"]) == expected
  end

end
