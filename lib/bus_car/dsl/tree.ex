defmodule BusCar.Dsl.Tree do

  def stem_leaf(field, opts, default_key, value) do
    %{field => leaf(opts, default_key, value)}
  end

  def leaf(opts, default_key, value) when opts |> is_list do
    opts
    |> Enum.into(%{})
    |> leaf(default_key, value)
  end
  def leaf(opts, default_key, value) when opts |> is_map do
    opts
    |> Map.put(default_key, value)
  end

  def accumulate_leaf(acc, key, opts, field, subkey, value) when acc |> is_map do
    acc |> Map.put(key, stem_leaf(field, opts, subkey, value))
  end
  def accumulate_leaf(acc, key, opts, field, subkey, value) when acc |> is_list do
    [ accumulate_leaf(%{}, key, opts, field, subkey, value) | acc ]
  end

end
