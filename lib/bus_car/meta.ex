defmodule BusCar.Meta do

  def index(name) when name |> is_binary do
    name |> String.to_atom
  end
  def index(name) when name |> is_atom do
    name
  end
  def index(%{:__struct__ => mod}) do
    mod.index
  end
  def index(_) do
    raise "Invalid Document Index Name"
  end

  def doctype(name) when name |> is_binary do
    name |> String.to_atom
  end
  def doctype(name) when name |> is_atom do
    name
  end
  def doctype(%{:__struct__ => mod}) do
    mod.doctype
  end
  def doctype(_) do
    raise "Invalid Document Doctype Name"
  end

end
