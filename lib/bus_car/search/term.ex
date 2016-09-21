defmodule BusCar.Search.Term do
  alias BusCar.Search.Term

  defstruct [
    field:    nil,
    value:    nil,
    options:  nil,
  ]
  def parse(dsl, acc) when acc |> is_list do
    parse_list(dsl, acc)
  end

  defp parse_list([:term, field, value, opts | rest ], acc) when opts |> is_list do
    if opts |> Keyword.keyword? do
      term = %{term: Term.as_json(field, value, opts)}
      parse_list(rest, [ term | acc ])
    else
      term = %{term: Term.as_json(field, value)}
      parse_list([ opts | rest ], [ term | acc ])
    end
  end
  defp parse_list([:term, field, value, :term | rest ], acc) do
    term = %{term: Term.as_json(field, value, :options)}
    parse_list([:term | rest], [term | acc])
  end
  defp parse_list([:term, field, value | rest ], acc) when length(acc) >= 0 do
    term = %{term: Term.as_json(field, value, :options)}
    parse_list(rest, [ term | acc ])
  end
  defp parse_list([:term, field, value | rest ], acc) do
    term = %{term: Term.as_json(field, value, :options)}
    parse_list(rest, [ term | acc ])
  end
  defp parse_list(rest, terms) do
    {rest, terms}
  end

  def as_json(field, value, opts \\ []) do
    new(field, value, opts)
    |> Searchable.to_json
  end

  def new(field, value, opts \\ [])
  def new(field, value, nil) do
    new(field, value, [])
  end
  def new(field, value, :options) do
    do_new(field, value, :options)
  end
  def new(field, value, opts) when is_list(opts) do
    do_new(field, value, opts)
  end
  def new(field, value, opts) when is_map(opts) or is_list(opts)  do
    do_new(field, value, opts)
  end

  defp do_new(field, value, opts) do
    %Term{
      field:    field,
      value:    value,
      options:  opts,
    }
  end

end

defimpl Searchable, for: BusCar.Search.Term do
  alias BusCar.Search.Term

  @invalids [nil, true, false, ""]

  def to_json(%Term{field: x}) when x in @invalids do
    raise "Invalid Term: Cannot jsonify match with #{inspect x} :field property"
  end
  def to_json(%Term{value: x}) when x in @invalids do
    raise "Invalid Term: Cannot jsonify match with #{inspect x} :value property"
  end
  def to_json(%Term{field: field, options: []} = t) when field |> is_binary do
    %{ field => t.value }
  end
  def to_json(%Term{field: field, options: []} = t) when field |> is_atom do
    %{ field => t.value }
  end
  def to_json(%Term{field: field, options: :options} = t) do
    %{ field => %{value: t.value}}
  end
  def to_json(%Term{options: opts} = t) when is_list(opts) do
    to_json(%{ t | options: opts |> Enum.into(%{}) })
  end
  def to_json(%Term{field: field, options: opts} = t) when opts |> is_map do
    map = opts
      |> Enum.into(%{})
      |> Map.put(:value, t.value)
    %{ field => map }
  end

end
