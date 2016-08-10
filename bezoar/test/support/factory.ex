defmodule Bezoar.Factory do
  use ExMachina.Ecto, repo: Bezoar.Repo
  import Ecto.Query

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

  def with_champs(player) do
    champs = Enum.map 1..4, fn _ ->
      insert_champ(player: player)
    end

    Bezoar.Repo.one!(Bezoar.Player |> where([p], p.id == ^player.id) |> preload(champs: :skills))
  end

  def champ_factory do
    %Bezoar.Champ{
      name: sequence(:champ, &"Champ #{&1}"),
      player: build(:player),
      champ_skills: [build(:champ_skill), build(:champ_skill)],
      hp_base: 20,
      hp_max: 20,
      hp: 20,
    }
  end

  def insert_champ(attrs \\ %{}) do
    cc = insert(:champ, attrs)
    Bezoar.Repo.one!(Bezoar.Champ |> where([c], c.id == ^cc.id) |> preload(:skills))
  end

  def champ_skill_factory do
    %Bezoar.ChampSkill{
      skill: build(:skill),
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
