defmodule BusCar.Repo do
  alias BusCar.Search

  defmacro __using__(_opts) do
    quote do

      alias BusCar.{Search, Document, Api, Query}

      def all(mod, query \\ []) do
        result = Search.search(mod.index, mod.doctype, query)
        Document.from_json(mod, result)
      end

      def get(mod, id) when id |> is_integer do
        get(mod, id |> Integer.to_string )
      end
      def get(mod, id) when id |> is_binary do
        result = Api.get(%{path: [mod.index, mod.doctype, id]})
        Document.from_json(mod, result)
      end

      def get_by(mod, map) when map |> is_map do
        all(mod, map |> Query.from_map)
      end

      def insert(%{:__struct__ => mod, id: id} = struct) do
        Api.post(%{
          path: [mod.index, mod.doctype, id],
          body: struct |> mod.__before_insert__ |> Document.to_json,
        })
      end

      def delete(%{:__struct__ => mod, id: id}) do
        delete(mod, id)
      end
      def delete(mod, id) when id |> is_integer do
        delete(mod, id |> Integer.to_string)
      end
      def delete(mod, id) when id |> is_binary do
        case Api.delete(%{path: [mod.index, mod.doctype, id]}) do
          %{"_id" => id}   -> :ok
          {:error, reason} -> {:error, reason}
          err              -> {:error, err}
        end
      end

    end
  end

end
