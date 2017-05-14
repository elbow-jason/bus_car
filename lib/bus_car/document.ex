defmodule BusCar.Document do
  @moduledoc """
  BusCar.Document is the module that keeps track of BusCar.Document
  metadata such as properties (see `BusCar.Document.property/3` macro) and

  """
  alias BusCar.{Meta, Property, Document}

  defstruct [
    index:    nil,
    mappings: nil,
  ]

  defmacro __using__(_opts) do
    quote do
      import BusCar.Document
      import BusCar.Document.Timestamp
      import BusCar.Changeset
    end
  end


  defmacro document(index, doctype, block) do
    quote do

      Module.put_attribute(__MODULE__, :index, unquote(index |> Meta.index))
      Module.put_attribute(__MODULE__, :doctype, unquote(doctype |> Meta.doctype))
      Module.register_attribute(__MODULE__, :properties, accumulate: true)

      #internals
      Module.register_attribute(__MODULE__, :internal_fields, accumulate: true)
      Module.put_attribute(__MODULE__, :internal_fields, :id)
      Module.put_attribute(__MODULE__, :internal_fields, :__struct__)
      Module.put_attribute(__MODULE__, :internal_fields, :_version)
      Module.put_attribute(__MODULE__, :internal_fields, :_score)

      # CRUD hooks
      Module.register_attribute(__MODULE__, :before_inserts, accumulate: true)
      Module.register_attribute(__MODULE__, :before_updates, accumulate: true)
      unquote(block)

      def index,      do: @index

      def doctype,    do: @doctype

      def type,       do: :object

      def mapping do
        %Document{
          index: index(),
          mappings: %{
            @doctype => %{
              :properties => Enum.reduce(@properties, %{}, &Property.to_mapping/2)
            }
          }
        }
      end

      defstruct @properties
        |> Enum.map(fn item -> {item.name, nil} end)
        |> Kernel.++(Enum.filter(@internal_fields, fn
            :__struct__ -> nil
            _           -> true
          end))


      @before_compile BusCar.Document
    end
  end

  defmacro __before_compile__(_opts) do
    quote do

      def __properties__,      do: @properties
      def __internal_fields__, do: @internal_fields

      def __before_insert__(%{:__struct__ => __MODULE__} = struct, opts \\ []) do
        {struct, _} = @before_inserts
          |> Enum.reduce({struct, []}, fn(func, {map, opts}) -> func.(map, opts) end)
        struct
      end

      def __before_update__(%{:__struct__ => __MODULE__} = struct, opts \\ []) do
        {struct, _} = @before_updates
          |> Enum.reduce({struct, []}, fn(func, {map, opts}) -> func.(map, opts) end)
        struct
      end

      @changeset @properties
        |> Enum.map(fn %{name: key, type: val} -> {key, val} end)
        |> Enum.into(%{})

      def __changeset__ do
        @changeset
      end
    end
  end

  defmacro property(name, type, opts \\ []) do
    quote do
      prop = Property.new(unquote(name), unquote(type), unquote(opts))
      Module.put_attribute(__MODULE__, :properties, prop)
    end
  end

  def from_json(mod, json) when json |> is_list do
    Enum.map(json, fn item -> from_json(mod, item) end)
  end
  def from_json(mod, json) when json |> is_map do
    struct = mod.__struct__
    src = json["_source"]
    struct
    |> Map.keys
    |> Enum.filter(fn
      :__struct__ -> false
      _ -> true
    end)
    |> Enum.map(fn item -> {item, Atom.to_string(item)} end)
    |> Enum.reduce(struct, fn({atom, string}, acc) -> Map.put(acc, atom, src[string]) end)
    |> append_internal_fields(mod, json)
  end

  defp append_internal_fields(struct, mod, json) do
    mod.__internal_fields__()
    |> Enum.filter(fn
      :__struct__ -> false
      :id -> false
      _ -> true
    end)
    |> Enum.reduce(struct, fn (field, acc) ->
      val = Map.get(json, field |> to_string)
      Map.put(acc, field, val)
    end)
    |> Map.put(:id, json["_id"])
  end

  def to_json(%{:__struct__ => mod} = struct) do
    struct
    |> Map.from_struct
    |> Map.drop([:__struct__ | mod.__internal_fields__() ])
  end

  def path(%{:__struct__ => mod, id: id}) do
    [mod.index, mod.doctype, id]
  end

  def index(%{:__struct__ => mod}) do
    index(mod)
  end
  def index(mod) when is_atom(mod) do
    mod.index
  end

  def remove_nils(%{:__struct__ => _} = struct) do
    struct
    |> to_json
    |> remove_nils
  end
  def remove_nils(%{} = map) do
    map
    |> Enum.into([])
    |> remove_nils
    |> Enum.into(%{})
  end
  def remove_nils(list) when list |> is_list do
    list
    |> Enum.filter(fn
      nil       -> nil
      {_, nil}  -> nil
      _         -> true
    end)
  end


end
