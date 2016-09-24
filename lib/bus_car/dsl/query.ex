defmodule BusCar.Dsl.Query do
  use BusCar.Dsl

  map_rule(:query, :bool)
  map_rule(:query, :nested)
  map_rule(:query, :constant_score)
  map_rule(:query, :query_string)
  map_rule(:query, :match)

end
