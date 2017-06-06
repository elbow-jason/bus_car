defmodule BusCarDocumentTest.Doggy do
  use BusCar.Document

  document "testing", "doggy" do
    property :name, :string
    property :age,  :integer
    property :is_hairy,  :bool, default: false
  end

end

defmodule BusCarDocumentTest do
  use ExUnit.Case
  doctest BusCar.Document
  alias BusCarDocumentTest.Doggy

  test "document macro gives a valid index" do
    assert Doggy.index == :testing
  end

  test "document macro gives a valid doctype" do
    assert Doggy.doctype == :doggy
  end

  test "document has a type :object" do
    assert Doggy.type == :object
  end

  test "document has the correct number of properties" do
    assert Doggy.__properties__ |> length == 3
  end

  test "document has the correct properties" do
    assert Doggy.__properties__ |> Enum.at(0) == %BusCar.Property{name: :is_hairy, options: [default: false], type: :bool}
    assert Doggy.__properties__ |> Enum.at(1) == %BusCar.Property{name: :age, options: [], type: :integer}
    assert Doggy.__properties__ |> Enum.at(2) == %BusCar.Property{name: :name, options: [], type: :string}
  end

  test "document mapping returns a valid Elasticsearch mapping" do
    assert Doggy.mapping == %BusCar.Document{
      index: :testing,
      mappings: %{
        doggy: %{
          properties: %{
            age:      %{type:  :integer},
            name:     %{type: :string},
            is_hairy: %{type: :bool}
          }
        }
      }
    }
  end
end
