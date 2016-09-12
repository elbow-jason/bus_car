defmodule BusCar.Cluster do
  alias BusCar.Api

  def health do
    Api.get!(%{path: "/_cluster/health"})
  end

end
