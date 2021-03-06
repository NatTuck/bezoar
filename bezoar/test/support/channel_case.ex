defmodule Bezoar.ChannelCase do
  @moduledoc """
  This module defines the test case to be used by
  channel tests.

  Such tests rely on `Phoenix.ChannelTest` and also
  imports other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      use Phoenix.ChannelTest

      alias Bezoar.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]
      import Bezoar.Factory

      # The default endpoint for testing
      @endpoint Bezoar.Endpoint
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
