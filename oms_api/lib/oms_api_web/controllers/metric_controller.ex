defmodule OmsApiWeb.MetricController do
  use OmsApiWeb, :controller

  alias OmsApiWeb.ReadAPI

  action_fallback OmsApiWeb.FallbackController

  defp rm_nil(:nil), do: 0
  defp rm_nil(x), do: x

  defp merge(acc, [max|tmax], [p50|tp50], [p95|tp95], [p99|tp99], offset, step) do
    merge(
      [%{
        max: rm_nil(max),
        p50: rm_nil(p50),
        p95: rm_nil(p95),
        p99: rm_nil(p99),
        t: offset
      } | acc], tmax, tp50, tp95, tp99, offset + step, step
    )
  end

  defp merge(acc, [], [], [], [], _offset, _step) do
    {:ok, Enum.reverse(acc)}
  end

  defp merge(_, _, _, _, _, _, _) do
    {:error, "length"}
  end

  defp merge_metrics(%{"data" => data, "step" => step}) do
    merge(
      [],
      data["latency.ms.max"],
      data["latency.ms.p50"],
      data["latency.ms.p95"],
      data["latency.ms.p99"],
      0,
      step
    )
  end

  defp read_latency(instance, resolution) do
    with {:ok, data} <- ReadAPI.get_latency(instance, resolution),
         {:ok, merged} <- merge_metrics(data)
    do
      %{latency: %{data: merged, start_time: data["start_time"]}}
    else
      {:error, err} -> %{error: err}
    end
  end

  def index(conn, %{"instance_id" => instance, "resolution" => resolution}) do
    render(conn, "index.json", read_latency(instance, resolution))
  end

  def index(conn, _params) do
    render(conn, "index.json", error: "parameter")
  end
end
