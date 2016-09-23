defmodule BusCar.Dsl.Prefix do
  # "prefix" : { "user" :  { "value" : "ki", "boost" : 2.0 } }
  def parse([:prefix, _, val | rest] = terms, acc) when acc |> is_list and val |> is_binary do
    parse_list(terms, acc)
  end
  def parse([:prefix, _, val | rest] = terms, acc) when acc |> is_map and val |> is_binary do
    parse_map(terms, acc)
  end

  def parse_list([:prefix, field, value, opts | rest], acc) when opts |> is_list do
    prefix = opts |> Enum.into(%{}) |> Map.put(:value, value |> String.downcase)
    parse_list(rest, [%{prefix: %{field => prefix}} | acc])
  end
  def parse_list([:prefix, field, value | rest], acc) do
    map = %{prefix: %{field => %{value: value |> String.downcase }}}
    parse_list(rest, [map | acc])
  end
  def parse_list(rest, acc) do
    {rest, acc}
  end

  def parse_map([:prefix, field, value, opts | rest], acc) when opts |> is_list do
    prefix = opts |> Enum.into(%{}) |> Map.put(:value, value |> String.downcase)
    parse_map(rest, acc |> Map.put(:prefix, %{field => prefix}))
  end
  def parse_map([:prefix, field, value | rest], acc) do
    parse_map(rest, acc |> Map.put(:prefix, %{field => %{value: value |> String.downcase}}))
  end
  def parse_map(rest, acc) do
    {rest, acc}
  end

end
