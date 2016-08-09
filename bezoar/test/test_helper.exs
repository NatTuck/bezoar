{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Bezoar.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Bezoar.Repo --quiet)

Ecto.Adapters.SQL.Sandbox.mode(Bezoar.Repo, :manual)
