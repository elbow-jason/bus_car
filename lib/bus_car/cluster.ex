defmodule BusCar.Cluster do
  alias BusCar.Api

  def health do
    Api.get(%{path: "/_cluster/health"})
  end

  def info do
    Api.get(%{path: "/"})
  end

  def nodes do
    Api.get(%{path: "/_cluster/nodes"})
  end

end
