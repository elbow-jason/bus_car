defmodule BusCar.Dsl.Leaf do

  defmacro __using__(_) do
    quote do
      import BusCar.Dsl.Leaf
    end
  end

  defmacro leaf_rule(root, stem) do
    quote do
      alias BusCar.Dsl.Tree

      def parse([ unquote(root) | rest ], acc) when acc |> is_map do
        parse_map([ unquote(root) | rest ], acc)
      end
      def parse([ unquote(root) | rest ], acc) when acc |> is_list do
        parse_list([ unquote(root) | rest ], acc)
      end

      defp parse_list([unquote(root), field, value, opts, unquote(root) | rest], acc) when opts |> is_list do
        acc = Tree.accumulate_leaf(acc, unquote(root), opts, field, unquote(stem), value)
        parse_list([unquote(root) | rest], acc)
      end
      defp parse_list([unquote(root), field, value, opts | rest], acc) when opts |> is_list do
        {rest, Tree.accumulate_leaf(acc, unquote(root), opts, field, unquote(stem), value)}
      end
      defp parse_list([unquote(root), field, value | rest], acc) do
        parse_list([unquote(root), field, value, [] | rest], acc)
      end

      defp parse_map([unquote(root), field, value, opts, unquote(root) | rest], acc) when opts |> is_list do
        acc = Tree.accumulate_leaf(acc, unquote(root), opts, field, unquote(stem), value)
        parse_map([unquote(root) | rest], acc)
      end
      defp parse_map([unquote(root), field, value, opts | rest], acc) when opts |> is_list do
        {rest, Tree.accumulate_leaf(acc, unquote(root), opts, field, unquote(stem), value)}
      end
      defp parse_map([unquote(root), field, value | rest], acc) do
        parse_map([unquote(root), field, value, [] | rest], acc)
      end

    end

  end
end
