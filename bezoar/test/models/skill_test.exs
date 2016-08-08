defmodule Bezoar.SkillTest do
  use Bezoar.ModelCase

  alias Bezoar.Skill

  @valid_attrs %{name: "some content", rules: %{}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Skill.changeset(%Skill{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Skill.changeset(%Skill{}, @invalid_attrs)
    refute changeset.valid?
  end
end
