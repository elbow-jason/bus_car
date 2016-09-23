defmodule BusCar.Search do
  alias BusCar.Api

  def search do
    do_search(nil, nil, "")
  end
  def search(dsl) when dsl |> is_list do
    Api.get(%{
      path: ["_search"],
      body: BusCar.Dsl.parse(dsl),
    })
  end
  def search(index, doctype, terms) when terms |> is_list do
    do_search(index, doctype, terms |> BusCar.Dsl.parse )
  end
  defp do_search(indices, doctype, terms) when indices |> is_list do
    do_search(indices |> Enum.join(","), doctype, terms)
  end
  defp do_search(index, doctypes, terms) when doctypes |> is_list do
    do_search(index, doctypes |> Enum.join(","), terms)
  end
  defp do_search(index, document, terms) when terms |> is_map or terms |> is_binary do
    Api.get(%{
      path: [index, document, "_search"],
      body: terms,
    })
  end

end
