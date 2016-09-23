defmodule BusCar.Dsl.Query do
  use BusCar.Dsl

  map_rule(:query, :bool)
  map_rule(:query, :nested)

end
