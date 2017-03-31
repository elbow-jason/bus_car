defmodule BusCar.Repo do
  alias BusCar.Search

  defmacro __using__(opts) do
    quote do

      alias BusCar.{Document, Query}
      require Logger
      require BusCar.Repo.Modules
      otp_app = unquote(opts) |> Keyword.get(:otp_app)
      BusCar.Repo.Modules.define_config(__MODULE__, otp_app)
      BusCar.Repo.Modules.define_api(__MODULE__, otp_app)

      BusCar.Repo.Modules.define_search(__MODULE__)
      BusCar.Repo.Modules.define_explain(__MODULE__)
      BusCar.Repo.Modules.define_cat(__MODULE__)
      BusCar.Repo.Modules.define_cluster(__MODULE__)
      BusCar.Repo.Modules.define_index(__MODULE__)

      @api Module.concat(__MODULE__, Api)
      def api do
        @api
      end
      @search Module.concat(__MODULE__, Search)

      def all(mod, query \\ [], _opts \\ [])
      def all(mod, [], opts) do
        all(mod, "", opts)
      end
      def all(mod, "", opts) do
        do_get_all(mod, "", opts)
      end
      def all(mod, query, opts) when mod |> is_atom and query |> is_list do
        do_get_all(mod, query |> BusCarDsl.parse, opts)
      end

      def do_get_all(mod, body, opts) do
        req = %{
          path: (mod.__struct__ |> Document.path) ++ ["_search"],
          body: body
        }
        case @api.get(req, opts) do
          result when result |> is_list -> Document.from_json(mod, result)
          {:error, reason} -> {:error, reason}
          _                -> {:error, :api_error}
        end
      end

      def get(mod, id, opts \\ [])
      def get(mod, id, opts) when id |> is_integer do
        get(mod, id |> Integer.to_string, opts )
      end
      def get(mod, id, opts) when id |> is_binary do
        req = %{path: [mod.index, mod.doctype, id]}
        case @api.get(req, opts) do
          {:error, reason} -> {:error, reason}
          result           -> Document.from_json(mod, result)
        end
      end

      def get_by(mod, map, opts \\ [])
      def get_by(mod, map, opts) when map |> is_map do
        all(mod, map |> Query.from_map, opts)
      end

      def insert(struct, opts \\ [])
      def insert(%{:__struct__ => mod, id: id} = struct, opts) do
        %{
          query: %{op_type: "create"},
          path: struct |> Document.path,
          body: struct |> mod.__before_insert__ |> Document.to_json,
        }
        |> @api.post(opts)
        |> handle_insert_response(mod)
      end

      defp handle_insert_response({:error, %{"status" => 409}}, _) do
        # 409 == conflict
        {:error, :id_already_exists}
      end
      defp handle_insert_response(%{"created" => true, "_id" => id} = map, mod) do
        # read own write
        case get(mod, id) do
          %{__struct__: mod} = struct ->
            struct
          {:error, reason} ->
            delete(mod, id)
            {:error, reason}
        end
      end

      def update(%Ecto.Changeset{} = cs, opts) do

      end

      def update(_) do
        raise "Repo.update only takes an Ecto.Changeset struct"
      end

      defp do_update(%{__struct__: mod, _version: vsn, id: id} = struct, opts \\ []) do
        # need optimistic locking on :_version here
        @api.put(%{
          query: %{version: vsn},
          path: struct |> Document.path,
          body: struct |> mod.__before_update__(opts) |> Document.to_json,
        }, opts)
      end

      def delete(mod, id \\ [], opts \\ [])
      def delete(%{:__struct__ => mod, id: id}, opts, _) do
        delete(mod, id, opts)
      end

      def delete(_, id, _) when id |> is_list do
        raise "#{__MODULE__} - must specify an id to delete"
      end
      def delete(mod, id, opts) when id |> is_binary or id |> is_integer do
        case @api.delete(%{path: [mod.index, mod.doctype, id]}, opts) do
          %{"_id" => id}   -> :ok
          {:error, reason} -> {:error, reason}
          err              -> {:error, err}
        end
      end

      def search(mod, query) when mod |> is_atom when query |> is_list do
        case @search.search(mod, query) do
          results when results |> is_list ->
            results
            |> Enum.map(fn item -> Document.from_json(mod, item) end)
          x ->
            {:error, x}
        end
      end

      def mapping(mod) do
        fields = mod.mapping()
        %{
          path: [to_string(fields.index)],
          body: %{mappings: fields.mappings}
        }
        |> @api.put
      end

    end
  end

end
