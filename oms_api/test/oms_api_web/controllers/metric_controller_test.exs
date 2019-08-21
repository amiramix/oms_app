defmodule OmsApiWeb.MetricControllerTest do
  use OmsApiWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "get 24hrs latency metrics", %{conn: conn} do
      conn = get(conn, Routes.instance_metric_path(conn, :index, 1, resolution: "24hrs"))
      data = json_response(conn, 200)["data"]
      assert is_map(data)
      assert Map.has_key?(data, "latency.ms.max")
    end

    test "get 72hrs latency metrics", %{conn: conn} do
      conn = get(conn, Routes.instance_metric_path(conn, :index, 1, resolution: "72hrs"))
      data = json_response(conn, 200)["data"]
      assert is_map(data)
      assert Map.has_key?(data, "latency.ms.max")
    end

    test "return error if invalid parameter", %{conn: conn} do
      conn = get(conn, Routes.instance_metric_path(conn, :index, 1, abc: "72hrs"))
      data = json_response(conn, 200)
      assert is_map(data)
      assert data == %{"error" => "parameter"}
    end

    test "return error if invalid resolution", %{conn: conn} do
      conn = get(conn, Routes.instance_metric_path(conn, :index, 1, resolution: "abc"))
      data = json_response(conn, 200)
      assert is_map(data)
      assert data == %{"error" => "resolution"}
    end
  end
end
