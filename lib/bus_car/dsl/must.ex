defmodule BusCar.Dsl.Must do
  use BusCar.Dsl

  list_rule(:must, :match)
  list_rule(:must, :term)

end
