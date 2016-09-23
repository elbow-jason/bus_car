# defmodule BusCar.Query.Match do
#   alias BusCar.Query.Match
#
#   @invalids [nil, true, false, ""]
#
#   defstruct [
#     field:          nil,
#     query:          nil,
#     options:        nil,
#   ]
#
#   def match(field, query, options \\ [])
#   def match(invalid, _, _) when invalid in @invalids do
#     raise "match requires a valid string, atom, or list as the first arg.\ngot: #{inspect invalid}"
#   end
#   def match(_, invalid, _) when invalid in @invalids do
#     raise "match requires a valid string or atom as the second arg \ngot: #{inspect invalid}"
#   end
#   def match(field, query, options) when field |> is_atom do
#     %{ :match => Match.new(field, query, options) }
#   end
#   def match(field, query, options) when field |> is_binary do
#     %{ :match => Match.new(field, query, options) }
#   end
#   def match(fields, query, options) when fields |> is_list do
#     %{ :multi_match => Match.new(fields, query, options) }
#   end
#
#   def new(field, query, opts \\ [])
#   def new(field, query, nil) do
#     new(field, query, [])
#   end
#   def new(field, query, opts) when is_list(opts) do
#     do_new(field, query, opts)
#   end
#   def new(field, query, opts) when is_map(opts) or is_list(opts)  do
#     do_new(field, query, opts)
#   end
#
#   defp do_new(field, query, opts) do
#     %Match{
#       field:    field,
#       query:    query,
#       options:  opts,
#     }
#   end
#
# end
#
#
# defimpl Searchable, for: BusCar.Query.Match do
#   alias BusCar.Query.Match
#
#   def to_json(%Match{field: nil}) do
#     raise "Invalid Match: Cannot jsonify match with nil :field property"
#   end
#   def to_json(%Match{query: nil}) do
#     raise "Invalid Match: Cannot jsonify match with nil :query property"
#   end
#   def to_json(%Match{field: field, query: query, options: []}) when field |> is_binary do
#     %{ field => query }
#   end
#   def to_json(%Match{field: field, query: query, options: []}) when field |> is_atom do
#     %{ field => query }
#   end
#   def to_json(%Match{field: fields, query: query, options: opts}) when is_list(fields) do
#     opts
#     |> Enum.into(%{})
#     |> Map.put(:fields, fields)
#     |> Map.put(:query, query)
#   end
#   def to_json(%Match{field: field, query: query, options: opts}) do
#     %{ field => Map.put(opts, :query, query) }
#   end
#
# end
