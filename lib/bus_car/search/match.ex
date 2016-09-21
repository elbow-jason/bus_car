defmodule BusCar.Search.Match do
  alias BusCar.Search.Match

  defstruct [
    field:    nil,
    query:    nil,
    options:  nil,
  ]

  def parse(dsl, acc) when acc |> is_list do
    parse_list(dsl, acc)
  end
  def parse(dsl, acc) when acc |> is_map do
    parse_map(dsl, acc)
  end

  defp parse_list([:match, field, value, opts | rest ], acc) when opts |> is_list do
    if opts |> Keyword.keyword? do
      parse_list(rest, [ %{match: Match.as_json(field, value, opts)} | acc ])
    else
      parse_list([ opts | rest ], [ %{match: Match.as_json(field, value)} | acc ])
    end
  end
  defp parse_list([:match, field, value, :match | rest ], acc) do
    #match was already in object
    match = %{match: Match.as_json(field, value, :options)}
    parse_list([ :match | rest], [ match | acc ])
  end
  defp parse_list([:match, field, value | rest ], acc) when length(acc) >= 0 do
    match = %{match: Match.as_json(field, value, :options)}
    parse_list(rest, [ match | acc ])
  end
  defp parse_list(rest, matches) do
    {rest, matches}
  end

  defp parse_map([:match, _field, _value, :match | _rest ], _acc) do
    raise "match multiple matches cannot be put into one object"
  end
  defp parse_map([:match, _field, _value, opts, :match | _rest ], acc) when opts |> is_list do
    raise "match multiple matches cannot be put into one object"
  end
  defp parse_map([:match, field, value, opts | rest ], acc) when opts |> is_list do
    if opts |> Keyword.keyword? do
      match = Match.as_json(field, value, opts)
      parse(rest, acc |> Map.put(:match, match))
    else
      match = Match.as_json(field, value)
      parse([ opts | rest ], acc |> Map.put(:match, match))
    end
  end

  def as_json(field, query, opts \\ []) do
    new(field, query, opts)
    |> Searchable.to_json
  end

  def new(field, query, opts \\ [])
  def new(field, query, nil) do
    new(field, query, [])
  end
  def new(field, query, :options) do
    do_new(field, query, :options)
  end
  def new(field, query, opts) when is_list(opts) do
    do_new(field, query, opts)
  end
  def new(field, query, opts) when is_map(opts) or is_list(opts)  do
    do_new(field, query, opts)
  end

  defp do_new(field, query, opts) do
    %Match{
      field:    field,
      query:    query,
      options:  opts,
    }
  end

end

defimpl Searchable, for: BusCar.Search.Match do
  alias BusCar.Search.Match

  @invalids [nil, true, false, ""]

  def to_json(%Match{field: x}) when x in @invalids do
    raise "Invalid Match: Cannot jsonify match with #{inspect x} :field property"
  end
  def to_json(%Match{query: x}) when x in @invalids do
    raise "Invalid Match: Cannot jsonify match with #{inspect x} :query property"
  end
  def to_json(%Match{field: field, options: []} = m) when field |> is_binary do
    %{ field => m.query }
  end
  def to_json(%Match{field: field, options: []} = m) when field |> is_atom do
    %{ field => m.query }
  end
  def to_json(%Match{field: field, options: :options} = m) do
    %{ field => %{query: m.query}}
  end
  def to_json(%Match{options: opts} = m) when is_list(opts) do
    to_json(%{ m | options: opts |> Enum.into(%{}) })
  end
  def to_json(%Match{field: field, options: opts} = m) when opts |> is_map do
    map = opts
      |> Enum.into(%{})
      |> Map.put(:query, m.query)
    %{ field => map }
  end

end
