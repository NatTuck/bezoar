defmodule Bezoar.Repo.Migrations.CreateChampSkill do
  use Ecto.Migration

  def change do
    create table(:champ_skills) do
      add :champ_id, references(:champs, on_delete: :delete_all)
      add :skill_id, references(:skills, on_delete: :delete_all)

      timestamps
    end

    create index(:champ_skills, [:champ_id])
    create index(:champ_skills, [:skill_id])
  end
end
