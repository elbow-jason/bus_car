defmodule BusCar.Type do
  @callback type() :: atom
  @callback properties() :: map | nil

  def aliased(key) do
    key
  end

end
