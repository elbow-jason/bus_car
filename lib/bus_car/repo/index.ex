defmodule BusCar.Repo.Index do
  
  defmacro __using__(opts) do
    quote do
      opts = unquote(opts)
      @repo Keyword.get(opts, :repo)
      if is_nil(@repo) do
        raise "BusCar.Repo.Index requires :repo. Got: #{inspect @repo}"
      end
      @api Module.concat(@repo, Api)

      use Slogger

      def new_index(name, body \\ "") when name |> is_binary do
        case @api.put(%{path: "/" <> name, body: body}, raw_response: true) do
          {:ok, %{status_code: 400}} -> {:error, :already_exists}
          {:ok, %{status_code: 200}} -> :ok
          err ->
            Slogger.error("new_index failure #{inspect err}")
            {:error, :internal_error}
        end
      end

      def aliases() do
        @api.get(%{path: "/_aliases"})
      end

      def list(query \\ %{}) do
        @api.get(%{path: "/_cat/indices", query: Map.merge(query, %{"v" => nil}) })
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
        @api.get(path: "/" <> index <> "/" <> word, query: query)
      end

    end

  end
end
