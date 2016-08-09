defmodule Bezoar.ChampTest do
  use Bezoar.ModelCase

  alias Bezoar.Champ

  @valid_attrs %{hp: 42, hp_max: 42, hp_base: 42, name: "Archer", player_id: -1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Champ.changeset(%Champ{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Champ.changeset(%Champ{}, @invalid_attrs)
    refute changeset.valid?
  end
end
