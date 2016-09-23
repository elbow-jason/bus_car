defmodule BusCar.Dsl.Nested do
  alias BusCar.Dsl.{Nested, Query}

  defstruct [
    path:       nil,
    query:      nil,
    options:    nil,
  ]

  def new(path, query, opts  \\ []) when path |> is_binary do
    %Nested{
      path:       path,
      query:      query,
      options:    opts,
    }
  end

  def parse([:nested, :path, path, opts, :query | rest ], %{} = acc) when is_binary(path) and is_list(opts) do
    mapped = opts
    |> Enum.map(%{})
    |> mapify_query(path, rest, acc)
  end

  def parse([:nested, :path, path, :query | rest ], %{} = acc) when path |> is_binary do
    %{}
    |> mapify_query(path, rest, acc)
  end

  defp mapify_query(opts_map, path, rest, acc) do
    {rest, query} = Query.parse([:query | rest], %{})
    nested = opts_map
      |> Map.merge(query)
      |> Map.put(:path, path)
    {rest, acc |> Map.put(:nested, nested)}
  end
end

defimpl Searchable, for: BusCar.Dsl.Nested do
  alias BusCar.Dsl.Nested

  @invalids [nil, true, false, ""]

  def to_json(%Nested{path: path}) when path in @invalids do
    raise "nested :path cannot be #{inspect path}"
  end
  def to_json(%Nested{query: query}) when query in @invalids do
    raise "nested :query cannot be #{inspect query}"
  end

  def to_json(%Nested{options: opts} = n) when opts |> is_list do
    %{ n | options: opts |> Enum.into(%{}) }
  end
  def to_json(%Nested{options: opts} = n) when opts |> is_map do
    opts
    |> Map.put(:path, n.path)
    |> Map.put(:query, n.query)
  end

end
