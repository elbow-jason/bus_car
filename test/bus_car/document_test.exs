defmodule BusCarDocumentTest.Doggy do
  use BusCar.Document

  document "animal", "dog" do
    property :name, :string
    property :age,  :integer
  end

end

defmodule BusCarDocumentTest do
  use ExUnit.Case
  doctest BusCar
  alias BusCarDocumentTest.Doggy

  test "document macro gives a valid index" do
    assert Doggy.index == :animal
  end

  test "document macro gives a valid doctype" do
    assert Doggy.doctype == :dog
  end

  test "document has a type :object" do
    assert Doggy.type == :object
  end

  test "document has the correct number of properties" do
    assert Doggy.__properties__ |> length == 2
  end

  test "document mapping returns a valid Elasticsearch mapping" do
    assert Doggy.mapping == %BusCar.Document{
      index: :animal,
      mappings: %{
        dog: %{
          properties: %{
            age: %{type:  :integer},
            name: %{type: :string},
          }
        }
      }
    }
  end
end
