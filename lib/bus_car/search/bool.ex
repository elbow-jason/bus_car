defmodule BusCar.Search.Bool do
  alias BusCar.Dsl
  alias BusCar.Search.{Must, MustNot, Should}

  def parse([:bool, :must | rest ], acc) when acc |> is_map do
    {rest, musted} = Must.parse([ :must | rest ], [])
    map = %{must: musted}
    update = fn (prev) -> Map.merge(prev, map) end
    acc = Map.update(acc, :bool, map, update)
    parse([:bool | rest], acc)
  end
  def parse([:bool, :must_not | rest ], acc) when acc |> is_map do
    {rest, musted_not} = MustNot.parse([ :must_not | rest ], [])
    map =  %{must_not: musted_not}
    update = fn (prev) -> Map.merge(prev, map) end
    acc = Map.update(acc, :bool, map, update)
    parse([:bool | rest], acc)
  end
  def parse([:bool, :should | rest ], acc) when acc |> is_map do
    {rest, shoulded} = Should.parse([ :should | rest ], [])
    map = %{should: shoulded}
    update = fn (prev) -> Map.merge(prev, map) end
    acc = Map.update(acc, :bool, map, update)
    parse([:bool | rest], acc)
  end
  def parse([:bool | rest], acc) do
    {rest, acc}
  end
  # def parse([:bool, :should   | rest ], acc) do: acc
  # def parse([:bool, :must_not | rest ], acc) do: acc
  # def parse([:bool, :must_not | rest ], acc) do: acc
  #
  # def parse([:bool | rest ], acc) do
  #
  # end
end
