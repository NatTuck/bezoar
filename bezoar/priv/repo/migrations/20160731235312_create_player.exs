defmodule Bezoar.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :email, :string
      add :secret, :string
      add :gold, :integer

      timestamps
    end

  end
end
