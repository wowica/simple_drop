defmodule SimpleDropWeb.Plugs.Auth do
  import Plug.Conn

  def init(_params) do
  end

  def call(conn, _opts) do
    auth =
      conn
      |> get_req_header("authorization")

    if check_auth(auth) do
      conn
    else
      conn
      |> resp(401, "unauthorized")
      |> halt()
    end
  end

  defp check_auth([]), do: false

  defp check_auth([creds | _] = _auth) do
    creds == app_creds()
  end

  defp app_creds() do
    Application.get_env(
      :simple_drop,
      SimpleDropWeb.Endpoint
    )[:events_auth]
  end
end
