defmodule Bezoar.Champ do
  use Bezoar.Web, :model

  schema "champs" do
    belongs_to :player, Bezoar.Player
    has_many :champ_skills, Bezoar.ChampSkill, on_delete: :delete_all
    has_many :skills, through: [:champ_skills, :skill]

    field :name, :string
    field :hp, :integer
    field :hp_max, :integer
    field :hp_base, :integer

    timestamps
  end

  @required_fields [:name, :hp_base, :player_id]
  @optional_fields []

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:player_id)
    |> cast_assoc(:champ_skills, required: false)
  end

  def to_map(champ) do
    champ
    |> Map.from_struct
    |> Map.delete(:__meta__)
    |> skills_to_maps 
    |> Map.drop([:champ_skills, :updated_at, :inserted_at, :player, :player_id])
    |> Bezoar.Util.keys_to_string
    |> Map.put("dead", false)
    |> Map.put("effects", [])
  end

  defp skills_to_maps(champ) do
    %{champ | skills: Enum.map(champ.skills, &Bezoar.Skill.to_map/1)}
  end
end
