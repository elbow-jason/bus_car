defmodule DslBoolTest do
  use ExUnit.Case
  doctest BusCar.Dsl.Bool
  alias BusCar.Dsl.Bool

  test "bool must" do
    result = Bool.parse([:bool, :must, :term, "apples", "oranges"], %{})
    expected = %{
      bool: %{
        must: [
          %{term: %{"apples" => %{value: "oranges"}}}
        ]
      }
    }
    assert result == {[], expected}
  end

  test "bool must_not" do
    result = Bool.parse([:bool, :must_not, :term, "apples", "oranges"], %{})
    expected = %{
      bool: %{
        must_not: [
          %{term: %{"apples" => %{value: "oranges"}}}
        ]
      }
    }
    assert result == {[], expected}
  end

  test "bool should" do
    result = Bool.parse([:bool, :should, :term, "apples", "oranges"], %{})
    expected = %{
      bool: %{
        should: [
          %{term: %{"apples" => %{value: "oranges"}}}
        ]
      }
    }
    assert result == {[], expected}
  end

  test "bool filter" do
    result = Bool.parse([:bool, :filter, :term, "apples", "oranges"], %{})
    expected = %{
      bool: %{
        filter: [
          %{term: %{"apples" => %{value: "oranges"}}}
        ]
      }
    }
    assert result == {[], expected}
  end

end
