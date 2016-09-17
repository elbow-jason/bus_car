defmodule BusCar.Query do

  @matchables [
    :match,
    :match_phrase,
  ]

  @listables [
    :sort,
    :should,
    :must,
    :must_not,
    :pre_tags,
    :post_tags,
    :actions,
  ]

  def generate([ [key] | rest ]) when key |> is_atom do
    [ key | rest ]
    |> generate
    |> Enum.into(%{})
  end
  def generate([:nested, :path, path, next | rest ]) do
    %{nested: %{:path => path, next => rest |> generate}}
  end
  def generate([:nested, [path: path], next | rest ]) do
    %{nested: %{:path => path, next => rest |> generate}}
  end
  def generate([matchable, field, value | rest ]) when matchable in @matchables do
    [%{ matchable => %{ field => %{ :query => value |> generate }}} | rest |> generate ]
  end
  def generate([ listable | rest ]) when listable in @listables do
    %{ listable => rest |> generate }
  end
  def generate([ {key, value} | rest ]) do
    [ {key, value |> generate } | rest |> generate ]
    |> Enum.into(%{})
  end
  def generate([ term | rest ]) when term |> is_atom do
    [{term, rest |> generate}]
    |> Enum.into(%{})
  end
  def generate(%{} = map) do
    map
    |> Enum.map(fn {k, v} -> {k, v |> generate} end)
    |> Enum.into(%{})
  end
  def generate(term) do
    term
  end


  # search [index: "bear_test"] do
  #   query do
  #     nested [path: "comments"] do
  #       query do
  #         bool do
  #           must do
  #             match "comments.author",  "John"
  #             match "comments.message", "cool"
  #           end
  #         end
  #       end
  #     end
  #   end
  # end

end
