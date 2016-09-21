defmodule BusCar.Cat do
  alias BusCar.Api

  def health(custom \\ %{}) do
    do_get("health", custom)
  end

  def nodes(custom \\ %{}) do
    do_get("nodes", custom)
  end

  def indices(custom \\ %{}) do
    do_get("indices", custom)
  end

  def do_get(suffix, custom) do
    custom
    |> Map.merge(%{path: ["_cat", suffix], query: %{v: nil}})
    |> Api.get
  end

end
