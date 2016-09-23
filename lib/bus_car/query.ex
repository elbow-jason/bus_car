defmodule BusCar.Query do
  alias BusCar.Api
  alias BusCar.Query

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
end
