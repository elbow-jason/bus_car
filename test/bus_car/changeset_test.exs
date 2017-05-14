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

 test "uncast returns ok tuple" do
    changes = %{
      name: "ruby",
      favorite_color: "red",
    }
    {:ok, result} = 
      %Kitty{}
      |> Changeset.cast(changes, [:name, :favorite_color])
      |> Changeset.uncast
    assert result.name == "ruby"
    assert result.favorite_color == "red"
  end

  test "validate_required fields cannot be blank" do
    model = %Kitty{}
    changes = %{
      name: nil,
      favorite_color: "red",
      other: "fasdasjd",
    }
    allowed = [:name, :favorite_color]
    result = 
      model
      |> Changeset.cast(changes, allowed)
      |> Changeset.validate_required([:name])
      |> Changeset.uncast
    assert result |> elem(0)
    cs = result |> elem(1)
    assert (cs.errors |> hd |> elem(0)) == :name
    assert (cs.errors |> hd |> elem(1)) == :cannot_be_blank
  end
end
