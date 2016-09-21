defmodule BusCar.Dsl do
  alias BusCar.Search.{Match, Nested, Term, Query, Bool}

  @parsers %{
    :match  => Match,
    :nested => Nested,
    :term   => Term,
    :bool   => Bool,
    :query  => Query,
  }

  def parse(dsl, acc \\ %{})
  def parse([], acc), do: acc
  def parse([:query | rest ], acc) do
    {rest, acc} = Query.parse([:query | rest], acc)
    parse(rest, acc)
  end

  def get_handler(key) do
    @parsers[key]
  end

  defmacro __using__(_opts) do
    quote do
      alias BusCar.Dsl
      import BusCar.Dsl, only: [parse_list_rule: 2]
    end
  end

  defmacro parse_list_rule(root, stem) do
    quote do
      def parse_list([unquote(root), unquote(stem) | rest], acc) do
        mod = BusCar.Dsl.get_handler(unquote(stem))
        {rest, parsed} = apply(mod, :parse, [[unquote(stem) | rest], []])
        parse_list([unquote(root) | rest], parsed ++ acc)
      end
    end
  end


end
