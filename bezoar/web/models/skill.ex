defmodule Bezoar.Skill do
  use Bezoar.Web, :model

  schema "skills" do
    has_many :champ_skills, Bezoar.ChampSkill, on_delete: :delete_all

    field :name, :string
    field :desc, :string
    field :rules, :map

    timestamps
  end

  @required_fields ~w(name rules)
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

  def to_map(skill) do
    skill
    |> Map.from_struct
    |> Map.drop([:__meta__, :champ_skills, :inserted_at, :updated_at])
  end
end
