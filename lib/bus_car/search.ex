defmodule BusCar.Search do
  alias BusCar.Api

  @suffix "_search"

  def search do
    do_search(nil, nil, "")
  end
  def search(index, doctype, terms) when terms |> is_list do
    do_search(index, doctype, terms |> BusCar.Query.generate )
  end
  defp do_search(indices, doctype, terms) when indices |> is_list do
    do_search(indices |> Enum.join(","), doctype, terms)
  end
  defp do_search(index, doctypes, terms) when doctypes |> is_list do
    do_search(index, doctypes |> Enum.join(","), terms)
  end
  defp do_search(index, document, terms) when terms |> is_map or terms |> is_binary do
    Api.get(%{
      path: make_path(index, document),
      body: terms,
    })
  end

  defp make_path(document, index) do
    "/" <> rel_path([document, index])
  end

  defp rel_path(parts) when parts |> is_list do
     parts ++ [@suffix]
    |> Enum.filter(fn item -> item end)
    |> Path.join
  end

end
