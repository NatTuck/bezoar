# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Bezoar.Repo.insert!(%Bezoar.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Ecto.Query

alias Bezoar.Repo

alias Bezoar.Player
alias Bezoar.Skill
alias Bezoar.Champ

Repo.delete_all(Player)
Repo.insert!(%Player{name: "Bob", email: "bob@example.com", secret: "", gold: 100})
Repo.insert!(%Player{name: "Sue", email: "sue@example.com", secret: "", gold: 100})

Repo.delete_all(Skill)
Repo.insert!(%Skill{name: "Stab", desc: "melee: 5 Damage", 
  rules: %{
    active: [
      %{range: 1,
        team: "enemy",
        pick: "first",
        effect: ["dmg", 5]},
      ],
  }})
stab = Repo.one(Skill |> where([s], s.name == "Stab"))

Repo.insert!(%Skill{name: "Maul", desc: "melee: 8 Damage", 
  rules: %{
    active: [
      %{range: 1,
        team: "enemy",
        pick: "first",
        effect: ["dmg", 8]},
      ],
  }})
maul = Repo.one(Skill |> where([s], s.name == "Maul"))

Repo.insert!(%Skill{name: "Heal", desc: "smart: Heal 5",
  rules: %{
    active: [
      %{range: 3,
        team: "ally",
        pick: "low_health",
        effect: ["heal", 5]},
    ],
  }})
heal = Repo.one(Skill |> where([s], s.name == "Heal"))

Repo.insert!(%Skill{name: "Wand", desc: "ranged: 3 Damage", 
  rules: %{
    active: [
      %{range: 4,
        team: "enemy",
        pick: "random",
        effect: ["dmg", 3]},
      ],
  }})
wand = Repo.one(Skill |> where([s], s.name == "Wand"))

make_cs = fn skills ->
  skills
  |> Enum.map(fn ss -> %{ skill_id: ss.id } end)
end

Repo.delete_all(Champ)

ps = Repo.all(Player)
Enum.each Repo.all(Player), fn pp ->
  Enum.each [0, 1], fn ii ->
    Repo.insert!(Champ.changeset(%Champ{}, %{ name: "#{pp.name}'s Fighter #{ii}", hp_base: 20, 
      champ_skills: make_cs.([stab, maul]), player_id: pp.id }))
    Repo.insert!(Champ.changeset(%Champ{}, %{ name: "#{pp.name}'s Priest #{ii}", hp_base: 15, 
      champ_skills: make_cs.([wand, heal]), player_id: pp.id }))
  end
end

