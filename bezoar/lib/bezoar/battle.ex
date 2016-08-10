defmodule Bezoar.Battle do
  use GenServer
  
  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def join(pid, player_id) do
    GenServer.call(pid, {:join, player_id})
  end

  def get(pid, player_id) do
    GenServer.call(pid, {:get, player_id})
  end

  def act(pid, player_id, actions) do
    GenServer.call(pid, {:act, player_id, actions})
  end

  # Server code
  def init(_bb) do
    players = Bezoar.Repo.all(Bezoar.Player) 
              |> Enum.map(&Bezoar.Player.to_map/1)
    battle = %{
      "players" => players, 
      "orders" => [],
      "events" => [],
    }
    {:ok, get_teams(battle)}
  end

  def handle_call({:join, _player_id}, _from, battle) do
    {:reply, :ok, battle}
  end

  def handle_call({:get, _player_id}, _from, battle) do
    {:reply, battle, battle}
  end

  def handle_call({:act, player_id, orders}, _from, battle) do
    battle = battle
    |> Map.put("orders", Enum.map(orders, fn xs -> [player_id | xs] end))
    |> apply_orders
    |> resolve_events
    {:reply, battle, battle}
  end
 
  # Game Logic

  def resolve_events(battle) do 
    Enum.reduce Map.get(battle, "events"), battle, fn _ev, acc ->
      acc
    end
  end

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

  def apply_orders(battle) do
    orders = Map.get(battle, "orders")
    battle = battle
    |> Map.put("orders", [])
    |> Map.put("events", [])
    Enum.reduce orders, battle, &apply_order/2
  end

  def apply_order([_player_id, champ_id, skill_id], battle) do
    champ   = get_champ(battle, champ_id)
    skill   = get_skill(champ, skill_id)
    effects = Map.get(Map.get(skill, "rules"), "active")

    events = Enum.reduce effects, Map.get(battle, "events"), fn eff, evts ->
      targs = pick_targets(battle, champ, eff)
      Enum.reduce targs, evts, fn tt, acc ->
        event = [Map.get(tt, "id"), champ_id, eff]
        [ event | acc ]
      end
    end

    Map.put(battle, "events", events)
  end

  def get_champ(battle, champ_id) do
    Enum.find(Map.get(battle, "champs"), fn cc -> Map.get(cc, "id") == champ_id end)
  end

  def get_skill(champ, skill_id) do
    Enum.find(Map.get(champ, "skills"), fn ss -> Map.get(ss, "id") == skill_id end)
  end

  def pick_targets(battle, champ, effect) do
    targs = Map.get(battle, "champs")
    |> filter_in_range(champ, effect)
    |> filter_target_team(champ, effect)

    nn = Map.get(effect, "targs", 1)

    case Map.get(effect, "pick") do
      "self" ->
        [champ]
      "random" ->
        Enum.take_random(targs, nn)
      "hurt" ->
        targs
        |> sort_by_health
        |> Enum.take(nn)
      "healthy" ->
        targs
        |> sort_by_health
        |> Enum.reverse
        |> Enum.take(nn)
    end
  end

  def sort_by_health(champs) do
    Enum.sort champs, fn tt ->
      chp = Map.get(tt, "hp")
      mhp = Map.get(tt, "hp_max")
      chp / mhp
    end
  end

  def champ_distance(ch0, ch1) do
    [y0, x0] = Map.get(ch0, "posn")
    [y1, x1] = Map.get(ch1, "posn")
    abs(y1 - y0) + abs(x1 - x0)
  end

  def filter_in_range(targs, champ, effect) do
    range = Map.get(effect, "range")
    Enum.filter targs, fn cc ->
      champ_distance(champ, cc) <= range
    end
  end

  def filter_target_team(targs, champ, effect) do
    team = Map.get(effect, "team")
    Enum.filter targs, fn cc ->
      case team do
        "ally" ->
          Map.get(champ, "player_id") == Map.get(cc, "player_id")
        "enemy" -> 
          Map.get(champ, "player_id") != Map.get(cc, "player_id")
        "any" ->
          true
      end
    end
  end
end
