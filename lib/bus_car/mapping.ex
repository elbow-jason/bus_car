defmodule BusCar.Mapping do

  defstruct [
    index:    nil,
    mappings: nil,
  ]

  defmacro __using__(_opts) do
    quote do
      import BusCar.Document
      import BusCar.Document.Timestamp
    end
  end



end
