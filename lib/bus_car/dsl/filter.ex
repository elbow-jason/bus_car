defmodule BusCar.Dsl.Filter do
  use BusCar.Dsl

  #map_rule(:filter, :term)
  list_rule(:filter, :term)
  list_rule(:filter, :range)
  map_rule(:filter, :range)
end
