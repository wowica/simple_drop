defmodule SimpleDrop.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      SimpleDrop.Repo,
      # Start the Telemetry supervisor
      SimpleDropWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SimpleDrop.PubSub},
      # Start the Endpoint (http/https)
      SimpleDropWeb.Endpoint
      # Start a worker by calling: SimpleDrop.Worker.start_link(arg)
      # {SimpleDrop.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SimpleDrop.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SimpleDropWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
