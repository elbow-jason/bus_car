defmodule BusCar.Index do
  alias BusCar.Api
  require Logger

  def new_index(name, body \\ "") when name |> is_binary do
    case Api.put(%{path: "/" <> name, body: body}, raw: true) do
      {:ok, %{status_code: 400}} -> {:error, :already_exists}
      {:ok, %{status_code: 200}} -> :ok
      x ->
        Logger.error("new_index failure #{inspect x}")
        {:error, :internal_error}
    end
  end

  def all(query \\ %{}) do
    Api.get(%{path: "/_cat/indices", query: %{"v" => nil}})
  end

  def stats(index, query \\ %{}) when index |> is_binary do
    Api.get(path: "/" <> index <> "/_stats", query: query)
  end

  def refresh(index, query \\ %{}) when index |> is_binary do
    Api.get(path: "/" <> index <> "/refresh", query: query)
  end
end
