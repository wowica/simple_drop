defmodule SimpleDropWeb.EventsController do
  use SimpleDropWeb, :controller

  require Logger

  def create(conn, params) do
    Logger.info("New event: #{inspect(params)}")

    json(conn, "")
  end
end
