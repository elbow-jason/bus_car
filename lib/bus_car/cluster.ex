defmodule BusCar.Cluster do
  alias BusCar.Api

  def health(q \\ %{}) do
    merge_get(%{path: "/_cluster/health"}, q)
  end

  def info(%{} = q \\ %{}) do
    merge_get(%{path: "/"}, q)
  end

  def state(%{} = q \\ %{}) do
    merge_get(%{path: "/_cluster/state"}, q)
  end

  def stats(%{} = q \\ %{}) do
    merge_get(%{path: "/_cluster/stats"}, q)
  end

  def pending_tasks(%{} = q \\ %{}) do
    merge_get(%{path: "/_cluster/pending_tasks"}, q)
  end

  def nodes(%{} = q \\ %{}) do
    merge_get(%{path: "/_nodes"}, q)
  end

  def node_stats do
    merge_get(%{path: "/_nodes/stats"}, %{})
  end
  def node_stats(custom) when custom |> is_map do
    merge_get(%{path: "/_nodes/stats"}, custom)
  end

  def node_stats(the_node, custom \\ %{}) when the_node |> is_binary do
    merge_get(%{path: "/_nodes/#{the_node}/stats"}, custom)
  end

  def merge_get(default, other) do
    other
    |> Map.merge(default)
    |> Api.get
  end
  #
  # GET /_cluster/health?pretty
  # GET /_cluster/health?wait_for_status=yellow&timeout=50s
  # GET /_cluster/state
  # GET /_cluster/stats?human&pretty
  # GET /_cluster/pending_tasks
  # GET /_nodes
  # GET /_nodes/stats
  # GET /_nodes/nodeId1,nodeId2/stats

end
