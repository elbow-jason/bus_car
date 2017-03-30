defmodule BusCarPropertyTest do
  use ExUnit.Case
  doctest BusCar.Property
  alias BusCar.Property

  test "new returns a %Property{} struct" do
    assert Property.new(:beef, :cake) == %Property{
      name: :beef,
      type: :cake,
      options: [],
    }
  end

    test "new returns a %Property{} struct with options" do
    assert Property.new(:beef, :cake, [virtual: true]) == %Property{
      name: :beef,
      type: :cake,
      options: [virtual: true],
    }
  end
end