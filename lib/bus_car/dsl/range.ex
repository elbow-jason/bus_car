defmodule BusCar.Dsl.Range do

  @comparators [
    :gt,
    :lt,
    :gte,
    :lte,
  ]

  def parse([:range | rest ], acc) when is_map(acc) do
    parse_map([:range | rest], acc)
  end

  defp parse_map([:range, field, comparator, value | rest], acc) when comparator in @comparators do
    comp_group = %{comparator => value}
    new_range = acc
      |> Map.get(:range, %{})
      |> Map.update(field, comp_group, fn prev -> Map.merge(prev, comp_group) end)
    parse_map([:range, field | rest ], acc |> Map.put(:range, new_range))
  end

  defp parse_map([:range, field | rest], acc) do
    {rest, acc}
  end

end
