defmodule BusCar.Search.Query do
  alias BusCar.Search.{Query, Bool}
  alias BusCar.Dsl

  def parse([:query, :bool | rest], acc) when acc |> is_map do
    {rest, bool} = Bool.parse([:bool |rest], %{})
     acc = Map.put(acc, :query, bool)
     parse([:query | rest], acc)
  end

  def parse([:query | rest], acc) do
    {rest, acc}
  end

end
