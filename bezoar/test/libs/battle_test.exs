defmodule Bezoar.BattleTest do
  use Bezoar.LibCase

  test "check initial teams" do
    {:ok, battle} = Bezoar.Battle.init
    assert battle.players == []
  end

  test "test application of damage" do
    champ = Bezoar.Champ.to_map(insert_champ(hp: 10))
    champ = Bezoar.Battle.apply_effect(["dmg", 3], champ)

    assert champ.hp == 7
  end

  test "test application of healing" do
    champ = Bezoar.Champ.to_map(insert_champ(hp: 10))
    champ = Bezoar.Battle.apply_effect(["heal", 5], champ)

    assert champ.hp == 15
  end
end
