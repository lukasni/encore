defmodule Encore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Encore.Repo,
      # Start the Telemetry supervisor
      EncoreWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Encore.PubSub},
      # Start the Endpoint (http/https)
      EncoreWeb.Endpoint
      # Start a worker by calling: Encore.Worker.start_link(arg)
      # {Encore.Worker, arg}
    ]

    :ets.new(:session, [:named_table, :public, read_concurrency: true])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Encore.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EncoreWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
