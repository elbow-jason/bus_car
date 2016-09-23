defmodule BusCar.Dsl.MustNot do
  use BusCar.Dsl

  list_rule(:must_not, :match)
  list_rule(:must_not, :term)
  list_rule(:must_not, :exists)
  list_rule(:must_not, :prefix)
end
