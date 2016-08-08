defmodule Bezoar do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Bezoar.Endpoint, []),
      # Start the Ecto repository
      supervisor(Bezoar.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(Bezoar.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bezoar.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Bezoar.Endpoint.config_change(changed, removed)
    :ok
  end

  # FIXME: This is probably a bad idea.
  defimpl Phoenix.HTML.Safe, for: Map do
    def to_string(map) do
      inspect(map)
      |> Phoenix.HTML.html_escape
    end

    def to_iodata(map) do
      {:safe, text} = inspect(map) |> Phoenix.HTML.html_escape
      [text]
    end 
  end
end
