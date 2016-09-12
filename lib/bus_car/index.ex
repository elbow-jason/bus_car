defmodule BusCar.Index do
  alias BusCar.Api

  def new_index(name, body \\ "") do
    case Api.put!(%{path: "/" <> name, body: body}, raw: true) do
      %{status_code: 400} -> {:error, :already_exists}
      %{status_code: 200} -> :ok
    end
  end

end
