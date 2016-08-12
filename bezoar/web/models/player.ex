defmodule Bezoar.Player do
  use Bezoar.Web, :model
  import Ecto.Query

  schema "players" do
    has_many :champs, Bezoar.Champ

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
  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def get_by_name(name) do
    Bezoar.Repo.one!(Bezoar.Player |> where([p], p.name == ^name))
  end

  def name_to_id(name) do
    get_by_name(name).id
  end

  def get_team(player_id) do
    pp = Bezoar.Repo.one!(Bezoar.Player 
          |> where([p], p.id == ^player_id)
          |> preload(champs: :skills))
    Enum.map(pp.champs, &Bezoar.Champ.to_map/1)
  end

  def to_map(player) do
    %{ id: player.id, name: player.name, }
  end
end
