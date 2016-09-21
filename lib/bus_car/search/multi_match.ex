defmodule BusCar.Search.MultiMatch do
  alias BusCar.Search.MultiMatch

  defstruct [
    fields:   nil,
    query:    nil,
    options:  nil,
  ]

  def as_json(fields, query, opts \\ []) do
    new(fields, query, opts)
    |> Searchable.to_json
  end

  def new(fields, query, opts \\ [])
  def new(fields, query, opts) when is_list(opts) do
    do_new(fields, query, opts)
  end

  defp do_new(fields, query, opts) do
    %MultiMatch{
      fields:   fields,
      query:    query,
      options:  opts,
    }
  end
end

defimpl Searchable, for: BusCar.Search.MultiMatch do
  alias BusCar.Search.MultiMatch

  @invalids [nil, true, false, ""]

  def to_json(%MultiMatch{fields: x}) when not is_list(x) do
    raise "Invalid MultiMatch: Cannot jsonify multi_match with non-list :fields property"
  end
  def to_json(%MultiMatch{query: q}) when q in @invalids do
    raise "Invalid Match: Cannot jsonify match with #{inspect q} :query property."
  end
  def to_json(%MultiMatch{options: opts} = mm) when is_list(opts) do
    to_json(%{ mm | options: opts |> Enum.into(%{}) })
  end
  def to_json(%MultiMatch{options: opts} = mm) when is_map(opts) do
    opts
    |> Map.put(:fields, mm.fields)
    |> Map.put(:query, mm.query)
  end

end
