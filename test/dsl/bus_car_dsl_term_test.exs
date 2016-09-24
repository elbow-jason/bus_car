defmodule BusCarDslTermTest do
  use ExUnit.Case
  doctest BusCar.Dsl.Term
  alias BusCar.Dsl.Term

  test "term without options" do
    assert Term.parse([:term, "key1", "value1"], %{}) == {[], %{
      :term => %{
        "key1" => %{value: "value1"},
      }
    }}
  end

  test "term with options" do
    assert Term.parse([
      :term, "key1", "value1", [boost: 2.0]
    ], %{}) == {[], %{
      :term => %{
        "key1" => %{boost: 2.0, value: "value1"}
      }
    }}
  end

  test "multi terms list" do
    assert Term.parse([
      :term, "key1", "value1",
      :term, "key2", "value2"
    ], []) == {[], [
      %{term: %{"key2" => %{value: "value2"}}},
      %{term: %{"key1" => %{value: "value1"}}}
    ]}
  end

  test "multi terms list with options" do
    assert Term.parse([
      :term, "key1", "value1", [boost: 2.0],
      :term, "key2", "value2"
    ], []) == {[], [
      %{term: %{"key2" => %{value: "value2"}}},
      %{term: %{"key1" => %{value: "value1", boost: 2.0}}}
    ]}
  end

  test "multi terms list with mixed options" do
    assert Term.parse([
      :term, "key1", "value1", [boost: 2.0],
      :term, "key2", "value2",
    ], []) == {[], [
      %{term: %{"key2" => %{value: "value2"}}},
      %{term: %{"key1" => %{value: "value1", boost: 2.0}}}
    ]}
  end

  test "multi terms list with all options" do
    assert Term.parse([
      :term, "key1", "value1", [boost: 2.0],
      :term, "key2", "value2", [boost: 1.1]
    ], []) == {[], [
      %{term: %{"key2" => %{value: "value2", boost: 1.1}}},
      %{term: %{"key1" => %{value: "value1", boost: 2.0}}}
    ]}
  end

end
