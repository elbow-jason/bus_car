defmodule BusCar.Repo.Explain do

  defmacro __using__(opts) do
    quote do
      opts = unquote(opts)
      @repo Keyword.get(opts, :repo)
      if is_nil(@repo) do
        raise "BusCar.Repo.Explain requires :repo. Got: #{inspect @repo}"
      end
      @api Module.concat(@repo, Api)

      def validate_and_explain(index, doctype, query_body) do
        @api.get(%{
          path: [index, doctype, "_validate", "query"],
          query: %{explain: nil},
          body: query_body
        })
      end

      def explain_match(index, doctype, id, body) do
        @api.get(%{
          path: [index, doctype, id, "_explain"],
          body: body,
        })
      end
    end
  end

end
