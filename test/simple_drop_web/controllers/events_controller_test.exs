defmodule SimpleDropWeb.EventsControllerTest do
  use SimpleDropWeb.ConnCase

  import ExUnit.CaptureLog

  describe "unauthed POST /events" do
    setup do
      conn =
        build_conn()
        |> put_req_header("accept", "application/json")

      {:ok, %{conn: conn}}
    end

    test "returns unauthorized", %{conn: conn} do
      conn = post(conn, "/events")
      assert response(conn, :unauthorized)
    end

    test "does not reach controller", %{conn: conn} do
      log =
        capture_log(fn ->
          post(conn, "/events", %{foo: "bar"})
        end)

      assert log != ~r/foo.*bar/
    end
  end

  @events_auth Application.get_env(
                 :simple_drop,
                 SimpleDropWeb.Endpoint
               )[:events_auth]

  describe "authed POST /events" do
    setup do
      conn =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", @events_auth)

      {:ok, %{conn: conn}}
    end

    test "returns 200 status with JSON", %{conn: conn} do
      conn = post(conn, "/events")
      assert json_response(conn, 200)
    end

    @tag capture_log: false
    test "logs events", %{conn: conn} do
      log =
        capture_log(fn ->
          post(conn, "/events", %{foo: "bar"})
        end)

      assert log =~ ~r/foo.*bar/
    end
  end
end
