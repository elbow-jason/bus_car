defmodule BusCar.Dsl do
  alias BusCar.Dsl

  @module_list [
    {Dsl.Term, :term},
    {Dsl.Bool, :bool},
    {Dsl.Must, :must},
    {Dsl.Match, :match},
    {Dsl.Query, :query},
    {Dsl.Fuzzy, :fuzzy},
    {Dsl.Range, :range},
    {Dsl.Nested, :nested},
    {Dsl.Filter, :filter},
    {Dsl.Exists, :exists},
    {Dsl.Prefix, :prefix},
    {Dsl.Regexp, :regexp},
    {Dsl.Should, :should},
    {Dsl.MustNot, :must_not},
    {Dsl.Wildcard, :wildcard},
    {Dsl.QueryString, :query_string},
    {Dsl.ConstantScore, :constant_score},
  ]
  @key_list @module_list
    |> Enum.map(fn {k, v} -> {v, k} end)

  def parse(dsl, acc \\ %{})
  def parse([], acc), do: acc
  def parse([:query | rest ], acc) do
    {rest, acc} = Dsl.Query.parse([:query | rest], acc)
    parse(rest, acc)
  end

  def get_key(mod) do
    case Keyword.fetch(@module_list, mod) do
      {:ok, key} -> key
      _ -> raise "Invalid Module - #{inspect mod}"
    end
  end

  def get_handler(key) do
    case Keyword.fetch(@key_list, key) do
      {:ok, mod} -> mod
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


  # defmacro stem_rule(root, stem) do
  #   quote do
  #     @stems unquote(stem)
  #     def parse_map([unquote(root), unquote(stem) | rest], acc) do
  #       mod = BusCar.Dsl.get_handler(unquote(stem))
  #       {rest, parsed} = apply(mod, :parse, [[unquote(stem) | rest], []])
  #       parse_map([unquote(root) | rest], acc |> Map.put(unquote(root), parsed))
  #     end
  #   end
  # end




end
