defmodule BusCar.Search.Must do
  alias BusCar.Search.{Match, Term}
  use BusCar.Dsl

  def parse(dsl, acc) when acc |> is_list do
    parse_list(dsl, acc)
  end

  parse_list_rule(:must, :match)
  parse_list_rule(:must, :term)

  def parse_list([:must | rest], acc) do
    {rest, acc}
  end
  # defp parse_list([:must, :match | rest], acc) do
  #   {rest, matches} = Match.parse([:match | rest], [])
  #   parse_list([:must | rest], matches ++ acc)
  # end
  #
  # defp parse_list([:must, :term | rest], acc) do
  #   {rest, terms} = Term.parse([:term | rest], [])
  #   parse_list([:must | rest], terms ++ acc)
  # end

end
