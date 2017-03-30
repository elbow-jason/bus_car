# defmodule BusCar.Query do

#   def from_map(%{} = map) do
#     [:query, :bool, :must | map_to_terms(map) ]
#   end

#   defp map_to_terms(map) do
#     map
#     |> Enum.map(fn
#       {k, v} when k |> is_atom   -> {Atom.to_string(k), v}
#       {k, v} when k |> is_binary -> {k, v}
#     end)
#     |> Enum.reduce([], fn ({k, v}, acc) -> [:term, k, v | acc] end)
#   end

# end
