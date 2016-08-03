defmodule Bezoar.Player do
  use Bezoar.Web, :model

  schema "players" do
    field :name, :string
    field :email, :string
    field :secret, :string
    field :gold, :integer

    timestamps
  end

  @required_fields ~w(name email secret gold)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
