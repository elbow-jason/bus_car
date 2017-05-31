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

  def check_validity(%Cs{errors: []} = cs) do
    %{ cs | valid?: true }
  end
  def check_validity(%Cs{errors: errors} = cs) when length(errors) > 0 do
    %{ cs | valid?: false }
  end

  def cast(model, changes, allowed_fields) do
    %Cs{
      model: model,
      changes: changes |> GenUtil.Map.to_atom_keys |> Map.take(allowed_fields)
    }
  end 

  def apply_changes(%Cs{model: model, changes: changes}) do
    changes
    |> Enum.reduce(model, fn ({k, v}, model_acc) ->
      Map.put(model_acc, k, v)
    end)
  end

  def uncast(%Cs{} = cs) do
    case check_validity(cs) do
      %{valid?: true} ->
        {:ok, apply_changes(cs)}
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