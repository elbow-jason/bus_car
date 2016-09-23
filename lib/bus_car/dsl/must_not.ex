defmodule BusCar.Dsl.MustNot do
  use BusCar.Dsl

  list_rule(:must_not, :match)
  list_rule(:must_not, :term)

end
