defmodule Bezoar.PlayerView do
  use Bezoar.Web, :view

  def render("index.json", %{players: players}) do
    %{data: render_many(players, Bezoar.PlayerView, "player.json")}
  end

  def render("show.json", %{player: player}) do
    %{data: render_one(player, Bezoar.PlayerView, "player.json")}
  end

  def render("player.json", %{player: player}) do
    %{id: player.id,
      name: player.name,
      email: player.email,
      secret: player.secret,
      gold: player.gold}
  end
end
