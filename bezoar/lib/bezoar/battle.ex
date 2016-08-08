defmodule Bezoar.Battle do
  use GenServer
  
  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def join(pid, player_id) do
    GenServer.cast(pid, {:join, player_id})
  end

  def get(pid, player_id) do
    GenServer.call(pid, {:get, player_id})
  end

  def act(pid, player_id, actions) do
    GenServer.cast(pid, {:act, player_id, actions})
  end

  # Server code
  def init(_bb) do
    players = Bezoar.Repo.all(Bezoar.Player) 
              |> Enum.map(&Bezoar.Player.to_map/1)
    battle = %{"players" => players} |> get_teams
    {:ok, battle}
  end

  def handle_cast({:join, player_id}, battle) do
    Process.send_after(self, {:begin, player_id}, 1000)
    {:noreply, battle}
  end

  def handle_call({:get, _player_id}, _from, battle) do
    {:reply, battle, battle}
  end

  def handle_cast(:act, {player_id, orders}, battle) do
    
  end
  
  def handle_info({:begin, player_id}, battle) do
    Bezoar.Endpoint.broadcast!("players:" <> to_string(player_id), "begin", battle)
    {:noreply, battle}
  end

  # Game Logic

  def get_teams(battle) do
    ids = battle |> Map.get("players") |> Enum.map(fn pp -> Map.get(pp, "id") end)
    champs = Enum.reduce Enum.with_index(ids), [], fn {p_id, pi}, champs ->
      team = Bezoar.Player.get_team(p_id)
      champs ++ Enum.map(Enum.with_index(team), &(add_posn(&1, pi)))
    end
    Map.put(battle, "champs", champs)
  end

  def add_posn({champ, ci}, pi) do
    px = pi * 2 + rem(ci, 2)
    py = div(ci, 2)
    Map.put(champ, "posn", [py, px])
  end 

  def check do
    {:ok, bb} = init(%{})
    get_teams(bb)
  end
end
