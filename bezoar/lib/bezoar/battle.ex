defmodule Bezoar.Battle do
  # This represents an active battle.

  # We care about states of the battle, and about
  # events that change the state.

  # The state is:
  # [ 
  #    $teamA: [ list of 4 Mobs ],
  #    $teamB: [ list of 4 Mobs ], 
  # ]
  def new do
    %{
      turn: "bob",
      players: [
        %{
          name: "bob",
          team: [goblin, goblin, orc, goblin],
        },
        %{
          name: "sue",
          team: [orc, orc, goblin, goblin],
        }
      ],
    }
  end

  # A Mob is a collection of properties.
  # We're especially interested in:
  #  - uuid
  #  - name
  #  - hp
  #  - skills (first is auto-attack)
  #  - passives
  #  - effects

  def punch do
    %{
      name: "Punch",
      dmg: 10,
      range: 1
    }
  end

  def uppercut do
    %{
      name: "Uppercut",
      dmg: 15,
      range: 1
    }
  end

  def stab do
    %{
      name: "Stab",
      dmg: 15,
      range: 1
    }
  end

  def goblin do
    %{
      uuid: make_uuid,
      name: "Goblin",
      hp: 100,
      skills: [punch, uppercut],
      passives: [],
      effects: [],
    }
  end

  def orc do
    %{
      uuid: make_uuid,
      name: "Orc",
      hp: 150,
      skills: [punch, stab],
    }
  end

  def make_uuid do
    :crypto.strong_rand_bytes(18) 
    |> Base.url_encode64
  end
end
