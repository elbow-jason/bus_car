defmodule BusCar.Property do
  alias BusCar.Property

  defstruct [
    name: nil,
    type: nil,
    options: nil,
  ]

  def new(name, type, options \\ []) do
    %Property{
      name: name,
      type: type,
      options: options
    }
  end

  def to_mapping(%Property{} = prop, acc \\ %{}) do
    acc
    |> Map.put(prop.name, payload(prop))
  end

  defp payload(%Property{} = prop) do
    %{ type: extract_type(prop) }
  end

  defp extract_type(%{:type => type_def}) do
    type_def
    |> extract_type
  end
  defp extract_type(type_def) do
    # type_def.type
    if :erlang.function_exported(type_def, :type, 0) do
      type_def.type
    else
      type_def
    end
  end

end
