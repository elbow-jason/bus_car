defmodule BusCar.Type do
  use Behaviour

  defcallback type() :: atom
  defcallback properties() :: map | nil

  def aliased(key) do
    case key do
      :string -> BusCar.Type.String
      :integer -> BusCar.Type.Integer
      _ -> key
    end
  end

end
