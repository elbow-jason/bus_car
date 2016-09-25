defmodule BusCar.Document.Timestamp do

  def put_inserted_at(%{inserted_at: _} = map, opts) when opts |> is_list do
    map = case Keyword.get(opts, :now) do
      nil -> %{ map | inserted_at: DateTime.utc_now }
      now -> %{ map | inserted_at: now }
    end
    {map, opts}
  end

  def put_updated_at(%{updated_at: _} = map, opts) when opts |> is_list do
    map = case Keyword.get(opts, :now) do
      nil -> %{ map | updated_at: DateTime.utc_now }
      now -> %{ map | updated_at: now }
    end
    {map, opts}
  end

  def put_now_in_options(map, opts) when opts |> is_list do
    {map, opts |> Keyword.put(:now, DateTime.utc_now)}
  end

  defmacro timestamps(_opts \\ []) do
    quote do
      alias BusCar.Document.Timestamp

      BusCar.Document.property(:inserted_at, :date)
      BusCar.Document.property(:updated_at, :date)

      Module.put_attribute(__MODULE__, :before_inserts, &Timestamp.put_inserted_at/2)
      Module.put_attribute(__MODULE__, :before_inserts, &Timestamp.put_updated_at/2)
      #put_now_in_options must come last so that it happens first at runtime
      Module.put_attribute(__MODULE__, :before_inserts, &Timestamp.put_now_in_options/2)
      Module.put_attribute(__MODULE__, :before_updates, &Timestamp.put_updated_at/2)

    end
  end
end
