defmodule BusCar.Repo.Cat do

  defmacro __using__(opts) do
    quote do
      @repo unquote(opts) |> Keyword.get(:repo)
      if @repo |> is_nil do
        raise "BusCar.Repo.Cat requires a :repo option"
      end
      @api Module.concat(@repo, Api)

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
        |> @api.get
      end

    end
  end

end
