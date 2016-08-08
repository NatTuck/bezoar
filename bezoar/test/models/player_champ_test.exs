defmodule Bezoar.PlayerChampTest do
  use Bezoar.ModelCase

  alias Bezoar.PlayerChamp

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PlayerChamp.changeset(%PlayerChamp{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PlayerChamp.changeset(%PlayerChamp{}, @invalid_attrs)
    refute changeset.valid?
  end
end
