defmodule Bezoar.ChampSkillTest do
  use Bezoar.ModelCase

  alias Bezoar.ChampSkill

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ChampSkill.changeset(%ChampSkill{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ChampSkill.changeset(%ChampSkill{}, @invalid_attrs)
    refute changeset.valid?
  end
end
