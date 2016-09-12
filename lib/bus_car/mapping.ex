defmodule BusCar.Mapping do

  defmacro __using__(_opts) do
    quote do
      import BusCar.Document
    end
  end

end
