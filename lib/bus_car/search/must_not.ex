defmodule BusCar.Search.MustNot do
  alias BusCar.Search.{Match, Term}
  use BusCar.Dsl

  def parse(dsl, acc) when acc |> is_list do
    parse_list(dsl, acc)
  end

  parse_list_rule(:must_not, :match)
  parse_list_rule(:must_not, :term)

  def parse_list([:must_not | rest], acc) do
    {rest, acc}
  end

end
