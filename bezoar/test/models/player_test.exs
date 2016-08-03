defmodule Bezoar.PlayerTest do
  use Bezoar.ModelCase

  alias Bezoar.Player

  @valid_attrs %{email: "some content", gold: 42, name: "some content", secret: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Player.changeset(%Player{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Player.changeset(%Player{}, @invalid_attrs)
    refute changeset.valid?
  end
end
