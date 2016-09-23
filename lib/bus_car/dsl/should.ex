defmodule BusCar.Dsl.Should do
  use BusCar.Dsl

  list_rule(:should, :match)
  list_rule(:should, :term)

end
