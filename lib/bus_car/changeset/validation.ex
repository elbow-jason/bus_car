defmodule BusCar.Changeset.Validation do
  alias BusCar.Changeset, as: Cs

  def validate_field(%Cs{} = cs, field, validator) do
    value = Map.get(cs.changes, field, Map.get(cs.model, field))
    case validator.(value) do
      :ok -> cs
      err -> cs |> Cs.put_error({field, err})
    end
  end

  def required(nil) do
    :cannot_be_blank
  end
  def required("") do
    :cannot_be_blank
  end
  def required(_) do
    :ok
  end

end