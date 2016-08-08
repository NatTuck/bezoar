defmodule Bezoar.Repo.Migrations.CreateSkill do
  use Ecto.Migration

  def change do
    create table(:skills) do
      add :name, :string
      add :desc, :string
      add :rules, :map

      timestamps
    end

  end
end
