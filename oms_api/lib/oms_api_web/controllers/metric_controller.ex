defmodule OmsApiWeb.MetricController do
  use OmsApiWeb, :controller

  alias OmsApiWeb.ReadAPI

  action_fallback OmsApiWeb.FallbackController

  defp read_latency(instance, resolution) do
    case ReadAPI.get_latency(instance, resolution) do
      {:ok, data} ->
        %{latency: data}
      {:error, err} ->
        %{error: err}
    end
  end

  def index(conn, %{"instance_id" => instance, "resolution" => resolution}) do
    render(conn, "index.json", read_latency(instance, resolution))
  end

  def index(conn, _params) do
    render(conn, "index.json", error: "parameter")
  end
end
