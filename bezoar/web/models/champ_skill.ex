defmodule Bezoar.ChampSkill do
  use Bezoar.Web, :model

  schema "champ_skills" do
    belongs_to :champ, Bezoar.Champ
    belongs_to :skill, Bezoar.Skill

    timestamps
  end

  @required_fields []
  @optional_fields [:champ_id, :skill_id]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
