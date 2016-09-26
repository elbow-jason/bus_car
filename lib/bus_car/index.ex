defmodule BusCar.Index do
  alias BusCar.Api
  require Logger

  def new_index(name, body \\ "") when name |> is_binary do
    case Api.put(%{path: "/" <> name, body: body}, raw_response: true) do
      {:ok, %{status_code: 400}} -> {:error, :already_exists}
      {:ok, %{status_code: 200}} -> :ok
      err ->
        Logger.error("new_index failure #{inspect err}")
        {:error, :internal_error}
    end
  end

  def aliases() do
    Api.get(%{path: "/_aliases"})
  end

  def list(query \\ %{}) do
    Api.get(%{path: "/_cat/indices", query: Map.merge(query, %{"v" => nil}) })
  end

  def stats(index, query \\ %{}) when index |> is_binary do
    get_index(index, "_stats", query)
  end

  def refresh(index, query \\ %{}) when index |> is_binary do
    get_index(index, "_refresh", query)
  end

  def segments(index, query \\ %{}) when index |> is_binary do
    get_index(index, "_segments", query)
  end

  def recovery(index, query \\ %{}) when index |> is_binary do
    get_index(index, "_recovery", query)
  end

  defp get_index(index, word, query) do
    Api.get(path: "/" <> index <> "/" <> word, query: query)
  end
end
