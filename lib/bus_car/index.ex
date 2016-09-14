defmodule BusCar.Index do
  alias BusCar.Api
  require Logger

  def new_index(name, body \\ "") do
    case Api.put(%{path: "/" <> name, body: body}, raw: true) do
      {:ok, %{status_code: 400}} -> {:error, :already_exists}
      {:ok, %{status_code: 200}} -> :ok
      x ->
        Logger.error("new_index failure #{inspect x}")
        {:error, :internal_error}
    end
  end

  def all(query \\ %{}) do
    Api.get(%{path: "/_cat/indices", query: %{"v" => true}})
  end

end
