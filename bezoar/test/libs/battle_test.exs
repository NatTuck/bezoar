defmodule Bezoar.BattleTest do
  use Bezoar.LibCase

  test "check initial teams" do
    {:ok, battle} = Bezoar.Battle.init
    assert Map.get(battle, "players") == []
  end
end
