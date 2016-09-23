defmodule BusCar.Dsl do
  alias BusCar.Dsl.{
    Query, Bool,
    Should, Must, MustNot, Filter,
    Match, Term,
    ConstantScore, Nested, Range
  }


  def parse(dsl, acc \\ %{})
  def parse([], acc), do: acc
  def parse([:query | rest ], acc) do
    {rest, acc} = Query.parse([:query | rest], acc)
    parse(rest, acc)
  end

  def get_key(mod) do
    case mod do
      ConstantScore -> :constant_score
      Match   -> :match
      Nested  -> :nested
      Term    -> :term
      Bool    -> :bool
      Query   -> :query
      Should  -> :should
      Must    -> :must
      MustNot -> :must
      Filter  -> :filter
      Range   -> :range
      _ -> raise "Invalid Module - #{inspect mod}"
    end
  end

  def get_handler(key) do
    case key do
      :match  -> Match
      :nested -> Nested
      :term   -> Term
      :bool   -> Bool
      :query  -> Query
      :should -> Should
      :must   -> Must
      :filter -> Filter
      :constant_score -> ConstantScore
      :range  -> Range
       _ -> raise "Invalid Handler Key - #{inspect key}"
    end
  end

  defmacro __using__(_opts) do
    quote do
      # the_root = Dict.get(unquote(opts), :root)
      # if not the_root do
      #   raise "`use BusCar.Dsl` requires a `root: <key>` where key is the name of this module in the DSL"
      # end
      alias BusCar.Dsl
      import BusCar.Dsl, only: [
        branch_list_rule: 2,
        list_rule: 2,
        map_rule: 2,
      ]

      the_root = Dsl.get_key(__MODULE__)
      Module.put_attribute __MODULE__, :root, the_root
      Module.register_attribute __MODULE__, :stems, accumulate: true

      @before_compile BusCar.Dsl

      def stems, do: @stems
      def root,  do: @root

    end
  end

  defmacro __before_compile__(_) do
    quote do

      def parse_list([ @root | rest ], acc) do
        {rest, acc}
      end

      def parse_map([ @root | rest ], acc) do
        {rest, acc}
      end

      if Module.defines?(__MODULE__, {:parse_map, 2}, :def) do
        def parse([@root, stem | rest], acc) when is_map(acc) do
          if stem in @stems do
            parse_map([@root, stem | rest], acc)
          else
            {[ stem | rest ], acc}
          end
        end
      end
      if Module.defines?(__MODULE__, {:parse_list, 2}, :def) do
        def parse([@root, stem | rest], acc) when is_list(acc) do
          if stem in @stems do
            parse_list([@root, stem | rest], acc)
          else
            {[ stem | rest ], acc}
          end
        end
      end

      def parse([@root | rest], acc) do
        {rest, acc}
      end

    end
  end


  defmacro branch_list_rule(root, stem) do
    quote do
      Module.put_attribute __MODULE__, :stems, unquote(stem)
      def parse_map([unquote(root), unquote(stem) | rest ], acc) when is_map(acc) do
        mod = BusCar.Dsl.get_handler(unquote(stem))
        # leaves go into a list as maps
        #IO.inspect {__MODULE__, "branch_list_rule", "=>", unquote(root), unquote(stem), mod, rest }
        {rest, leaves} = apply(mod, :parse, [[ unquote(stem) | rest ], []])
        map = %{} |> Map.put(unquote(stem), leaves)
        update = fn (prev) -> Map.merge(prev, map) end
        acc = Map.update(acc, unquote(root), map, update)
        parse_map([unquote(root) | rest], acc)
      end
    end
  end

  defmacro list_rule(root, stem) do
    quote do
      Module.put_attribute __MODULE__, :stems, unquote(stem)
      def parse_list([unquote(root), unquote(stem) | rest], acc) do
        mod = BusCar.Dsl.get_handler(unquote(stem))
        #IO.inspect {__MODULE__, "list_rule", "=>", unquote(root), unquote(stem), mod, rest }
        {rest, parsed} = apply(mod, :parse, [[unquote(stem) | rest], []])
        parse_list([unquote(root) | rest], parsed ++ acc)
      end
    end
  end

  defmacro map_rule(root, stem) do
    quote do
      @stems unquote(stem)
      def parse_map([unquote(root), unquote(stem) | rest], acc) do
        mod = BusCar.Dsl.get_handler(unquote(stem))
        #IO.inspect {__MODULE__, "map_rule", "=>", unquote(root), unquote(stem), mod, rest }
        {rest, parsed} = apply(mod, :parse, [[unquote(stem) | rest], %{}])
        parse_map([unquote(root) | rest], acc |> Map.put(unquote(root), parsed))
      end
    end
  end
  #
  # defmacro stem_rule(root, stem) do
  #   quote do
  #     @stems unquote(stem)
  #     def parse_map([unquote(root), unquote(stem) | rest], acc) do
  #       mod = BusCar.Dsl.get_handler(unquote(stem))
  #       {rest, parsed} = apply(mod, :parse, [[unquote(stem) | rest], []])
  #       parse_map([unquote(root) | rest], acc |> Map.put(unquote(root), parsed))
  #     end
  #   end
  #
  # end


end
