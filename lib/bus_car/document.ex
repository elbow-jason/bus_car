defmodule BusCar.Document do
  alias BusCar.{Meta, Property}

  defmacro document(index, doctype, block) do
    quote do
      Module.put_attribute(__MODULE__, :index, unquote(index |> Meta.index))
      Module.put_attribute(__MODULE__, :doctype, unquote(doctype |> Meta.doctype))
      Module.register_attribute(__MODULE__, :properties, accumulate: true)
      unquote(block)

      def index,      do: @index
      def doctype,    do: @doctype
      def properties, do: @properties
      def type,       do: :object
      def mapping do
        %{
          index => %{
            doctype => %{
              :properties => Enum.reduce(@properties, %{}, &Property.to_mapping/2)
            }
          }
        }
      end
    end
  end

  defmacro property(name, type, opts \\ []) do
    quote do
      #props = Module.get_attribute(__MODULE__, :properties) || []
      prop = Property.new(unquote(name), unquote(type), unquote(opts))
      Module.put_attribute(__MODULE__, :properties, prop)
    end
  end

end
