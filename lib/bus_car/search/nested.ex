defmodule BusCar.Query.Nested do
  alias BusCar.Query.Nested

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
end

defimpl Searchable, for: BusCar.Query.Nested do
  alias BusCar.Query.Nested

  @invalids [nil, true, false, ""]

  def to_json(%Nested{path: path}) when path in @invalids do
    raise "nested :path cannot be #{inspect path}"
  end
  def to_json(%Nested{query: query}) when query in @invalids do
    raise "nested :query cannot be #{inspect query}"
  end

  def to_json(%Nested{options: opts} = n)when opts |> is_list do
    %{ n | options: opts |> Enum.into(%{}) }
  end
  def to_json(%Nested{options: opts} = n) when opts |> is_map do
    opts
    |> Map.put(:path, n.path)
    |> Map.put(:query, n.query)
  end

end
