defprotocol Searchable do
  @doc """
  returns a map, list, or other thing that can be successfully encode to json
  """
  def to_json(data)
end

defimpl Searchable, for: Map do
  def to_json(map) when map |> is_map do
    map
    |> Enum.map(fn
      {key, val} when key |> is_atom   -> {key |> Atom.to_string, val |> Searchable.to_json}
      {key, val} when key |> is_binary -> {key, val |> Searchable.to_json}
    end)
    |> Enum.into(%{})
  end
end

defimpl Searchable, for: List do
  def to_json(list) when list |> is_list do
    Enum.map(list, fn item -> Searchable.to_json(item) end)
  end
end

defimpl Searchable, for: Atom do
  def to_json(true),  do: true
  def to_json(false), do: false
  def to_json(nil),   do: nil
  def to_json(x),     do: Atom.to_string(x)
end

defimpl Searchable, for: Float do
  def to_json(x),   do: x
end

defimpl Searchable, for: String do
  def to_json(x),   do: x
end

defimpl Searchable, for: Integer do
  def to_json(x),   do: x
end
