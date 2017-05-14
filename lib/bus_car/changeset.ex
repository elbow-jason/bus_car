defmodule BusCar.Changeset do

  alias BusCar.Changeset, as: Cs
  alias BusCar.Changeset.Validation

  defstruct [
    model:      nil,
    changes:    nil,
    errors:     [],
    valid?:     false,
  ]

  def put_error(%Cs{errors: errors} = cs, {_, _} = new_error) do
    %{ cs | errors: [ new_error | errors ]}
  end

  defp check_validity(%Cs{errors: []} = cs) do
    %{ cs | valid?: true }
  end
  defp check_validity(%Cs{errors: errors} = cs) when length(errors) > 0 do
    %{ cs | valid?: false }
  end

  def cast(model, changes, allowed_fields) do
    %Cs{
      model: model,
      changes: Map.take(changes, allowed_fields)
    }
  end

  def uncast(%Cs{model: model, changes: changes} = cs) do
    case check_validity(cs) do
      %{valid?: true} ->
        {:ok, changes |> Enum.map(fn {k, v} -> Map.put(model, k, v) end) }
      _ -> 
        {:error, cs}
    end
  end

  def validate_required(%Cs{} = cs, required_fields) when is_list(required_fields) do
    required_fields
    |> Enum.reduce(cs, fn (field, cs_acc) ->
      Validation.validate_field(cs_acc, field, &Validation.required/1)
    end)
  end

end