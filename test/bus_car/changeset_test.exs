defmodule BusCarDocumentTest.Kitty do
  use BusCar.Document

  document "animal", "cat" do
    property :name, :string
    property :age,  :integer
    property :is_hairy,  :bool, default: true
  end

end

defmodule BusCarChangesetTest do
  use ExUnit.Case
  doctest BusCar.Changeset
  alias BusCarDocumentTest.Kitty
  alias BusCar.Changeset


  test "cast returns a new unvalidated changeset" do
    model = %Kitty{}
    changes = %{
      name: "fleep",
      favorite_color: "red",
      other: "fasdasjd",
    }
    allowed = [:name, :favorite_color]
    new_changeset = 
      model
      |> Changeset.cast(changes, allowed)
    assert new_changeset.valid? == false
    refute Map.has_key?(new_changeset.changes, :other)
  end

  test "validate_required allows unrequired field to pass but required fields cannot be blank" do
    model = %Kitty{}
    changes = %{
      name: "fleep",
      favorite_color: "red",
      other: "fasdasjd",
    }
    allowed = [:name, :favorite_color]
    model
    |> Changeset.cast(changes, allowed)
    |> Changeset.validate_required([:name])
  end
end
