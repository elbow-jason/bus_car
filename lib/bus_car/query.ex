defmodule BusCar.Query do
  alias BusCar.Api
  alias BusCar.Query.Match



  defmacro __using__(_opts) do
    quote do
      import BusCar.Query.Match, only: [match: 3, match: 2]
    end
  end

  def generate(%{} = map) do
    map
    |> Enum.map(fn {k, v} -> {k, v |> generate} end)
    |> Enum.into(%{})
  end
  def generate(term) do
    term
  end

  defp match_matchables(keyword, field, value, options \\ []) do
    case keyword do
      :match -> Match.match(field, value, options)
      _      -> %{ keyword => %{ field => %{ :query => value |> generate }}}
    end
  end

  def validate_and_explain(index, doctype, query_body) do
    Api.get(%{
      path: [index, doctype, "_validate", "query"],
      query: %{explain: nil},
      body: query_body
    })
  end

  def explain_match(index, doctype, id, body) do
    Api.get(%{
      path: [index, doctype, id, "_explain"],
      body: body,
    })
  end

  def to_json(q) do
    Searchable.to_json(q)
  end

end

defimpl Searchable, for: BusCar.Query do
  def to_json()
end
