defmodule OmsApiWeb.MetricView do
  use OmsApiWeb, :view
  alias OmsApiWeb.MetricView

  def render("index.json", data) do
    cond do
      Map.has_key?(data, :latency) ->
        render_one(data, MetricView, "metric.json")
      Map.has_key?(data, :error) ->
        render_one(data, MetricView, "error.json")
    end
  end

  def render("metric.json", %{metric: metric}) do
    metric.latency
  end

  def render("error.json", %{metric: metric}) do
    %{error: metric.error}
  end
end
