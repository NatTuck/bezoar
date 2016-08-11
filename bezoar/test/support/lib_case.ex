defmodule Bezoar.LibCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Bezoar.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Bezoar.ModelCase

      import Bezoar.Factory
    end
  end

  setup _tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Bezoar.Repo)

    Ecto.Adapters.SQL.Sandbox.mode(Bezoar.Repo, {:shared, self()})
    on_exit fn ->
      Ecto.Adapters.SQL.Sandbox.mode(Bezoar.Repo, :manual)
    end

    :ok
  end
end
