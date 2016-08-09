defmodule Bezoar.Factory do
  use ExMachina.Ecto, repo: Bezoar.Repo

  def start_em do
    {:ok, _} = Application.ensure_all_started(:ex_machina)
    :ok
  end

  def player_factory do
    pnum = sequence(:player, &"#{&1}")

    %Bezoar.Player{
      name: "Player #{pnum}",
      email: "player-#{pnum}@example.com",
      secret: "",
      gold: 100,
    }
  end

  def champ_factory do
    %Bezoar.Champ{
      name: sequence(:champ, &"Champ #{&1}"),
      player: build(:player),
      skills: [build(:skill), build(:skill)],
      hp_base: 20,
      hp_max: 20,
      hp: 20,
    }
  end

  def skill_factory do
    %Bezoar.Skill{
      name: sequence(:skill, &"Skill #{&1}"),
      desc: "Do a thing",
      rules: %{"active" => [%{
            "effect" => ["dmg", 2],
            "range"  => 1,
            "pick"   => "self",
            "team"   => "ally",
          }]},
    }
  end
end
