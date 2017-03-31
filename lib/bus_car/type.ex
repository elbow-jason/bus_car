defmodule BusCar.Type do
  @callback type() :: atom
  @callback properties() :: map | nil

  def aliased(key) do
    key
  end
    # case key do
    #   # :string   -> BusCar.Type.String
    #   # :integer  -> BusCar.Type.Integer
    #   _ -> key
    # end

end
