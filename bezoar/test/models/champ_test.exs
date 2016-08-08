defmodule Bezoar.ChampTest do
  use Bezoar.ModelCase

  alias Bezoar.Champ

  @valid_attrs %{hp: 42, hp_max: 42, name: "some content"}
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
