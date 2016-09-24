defmodule BusCarTest.Doggy do
  use BusCar.Mapping

  document "animal", "dog" do
    property :name, :string
    property :age,  :integer
  end

end

defmodule BusCarTest do
  use ExUnit.Case
  doctest BusCar
  alias BusCarTest.Doggy

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
    assert Doggy.properties |> length == 2
  end

  test "document mapping returns a valid Elasticsearch mapping" do
    assert Doggy.mapping == %{
      animal: %{
        dog: %{
          properties: %{
            age: %{
              type: :integer
            },
            name: %{
              type: :string
            },
          }
        }
      }
    }
  end
end

defmodule BusCarPropertyTest do
  use ExUnit.Case
  doctest BusCar.Property
  alias BusCar.Property
  alias BusCarTest.Doggy

  test "new returns a %Property{} struct" do
    assert Property.new(:beef, :cake) == %Property{
      name: :beef,
      type: :cake,
      options: [],
    }
  end

end
