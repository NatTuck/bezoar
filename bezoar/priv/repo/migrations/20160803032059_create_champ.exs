defmodule Bezoar.Repo.Migrations.CreateChamp do
  use Ecto.Migration

  def change do
    create table(:champs) do
      add :player_id, references(:players, on_delete: :delete_all)
      add :name, :string
      add :hp, :integer
      add :hp_max, :integer
      add :hp_base, :integer

      timestamps
    end
  end
end
