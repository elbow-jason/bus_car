defmodule BusCar.Dsl.Exists do

  def parse([:exists, :field | rest], acc) when acc |> is_list do
    parse_list([:exists, :field | rest], acc)
  end
  def parse([:exists, :field | rest], acc) when acc |> is_map do
    parse_map([:exists, :field | rest], acc)
  end
  def parse(rest, acc) do
    {rest, acc}
  end

  defp parse_list([:exists, :field, field | rest], acc) do
    parse(rest, [%{exists: %{field: field}} | acc])
  end

  defp parse_map([:exists, :field, field | rest], acc) do
    acc = acc |> Map.put(:exists, %{field: field})
    parse(rest, acc)
  end

end
