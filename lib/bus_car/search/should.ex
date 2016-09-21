defmodule BusCar.Search.Should do
  alias BusCar.Search.{Match, Term}
  use BusCar.Dsl

  def parse(dsl, acc) when acc |> is_list do
    parse_list(dsl, acc)
  end
  # defp parse_list([:should, :match | rest], acc) do
  #   {rest, matches} = Match.parse([:match | rest], [])
  #   parse_list([:should | rest], matches ++ acc)
  # end
  parse_list_rule(:should, :match)
  parse_list_rule(:should, :term)


  def parse_list([:should | rest], acc) do
    {rest, acc}
  end
end
