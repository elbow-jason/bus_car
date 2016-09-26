defmodule BusCar.Repo.Helpers do
  def concat_names({_, _, root}, name) do
    concat_names(root, name)
  end
  def concat_names(root, name) when root |> is_atom and name |> is_atom do
    string_names(root, name)
    |> String.to_atom
  end

  defp string_names(root, name) do
    (root |> Atom.to_string) <> "." <> (name |> Atom.to_string |> remove_elixir)
  end

  defp remove_elixir("Elixir." <> name) do
    name |> remove_elixir
  end
  defp remove_elixir(name) do
    name
  end
end
