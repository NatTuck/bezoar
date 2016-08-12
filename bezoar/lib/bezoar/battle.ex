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
  def init(_bb \\ %{}) do
    players = Bezoar.Repo.all(Bezoar.Player) |> Enum.map(&Bezoar.Player.to_map/1)
    battle = %{ new | players: players } |> get_teams
    {:ok, battle}
  end

  def handle_call({:join, _player_id}, _from, battle) do
    {:reply, :ok, battle}
  end

  def handle_call({:get, player_id}, _from, battle) do
    send_to(player_id, "battle", battle) 
    {:reply, battle, battle}
  end

  def handle_call({:act, player_id, orders}, _from, battle) do
    battle = battle
    |> Map.put(:orders, Enum.map(orders, fn xs -> [player_id | xs] end))
    |> add_default_orders
    |> apply_orders
    |> resolve_events
    send_to(player_id, "battle", battle)
    {:reply, :ok, battle}
  end

  def handle_info({:send, player_id, tag, msg}, battle) do
    Bezoar.Endpoint.broadcast("players:" <> to_string(player_id), tag, msg)
    {:noreply, battle}
  end

  def send_to(player_id, tag, msg) do
    msg = Bezoar.Util.keys_to_string(msg)
    Process.send_after(self, {:send, player_id, tag, msg}, 10)
  end
 
  # Game Logic

  def new do
    %{
      players: [],
      orders:  [],
      events:  [],
    }
  end

  def add_default_orders(battle) do
    need_orders = Enum.filter battle.champs, fn cc ->
      Enum.reduce battle.orders, true, fn [_, c_id, _], acc ->
        acc && c_id != cc.id
      end
    end

    orders = Enum.reduce need_orders, battle.orders, fn cc, acc ->
      p_id = cc.player_id
      s_id = hd(cc.skills).id
      [ [p_id, cc.id, s_id] | acc ]
    end

    Map.put(battle, :orders, orders)
  end

  def resolve_events(battle) do 
    Enum.reduce battle.events, battle, fn [t_id, _s_id, %{"effect" => effect}] , acc ->
      tt0 = get_champ(acc, t_id)
      tt1 = apply_effect(effect, tt0)
      put_champ(acc, tt1)
    end
  end

  def apply_effect(["dmg", xx], champ) do
    hp = champ.hp - xx
    %{champ | hp: hp }
  end

  def apply_effect(["heal", xx], champ) do
    hp = champ.hp + xx
    %{champ | hp: hp }
  end

  def get_teams(battle) do
    ids = battle.players  |> Enum.map(&(&1.id))
    champs = Enum.reduce Enum.with_index(ids), [], fn {p_id, pi}, champs ->
      team = Bezoar.Player.get_team(p_id)
      team = if pi == 0 do
        Enum.reverse(team)
      else
        team
      end
      champs ++ Enum.map(Enum.with_index(team), &(add_posn(&1, pi)))
    end
    
    Map.put(battle, :champs, champs)
  end

  def add_posn({champ, ci}, pi) do
    px = pi * 2 + rem(ci, 2)
    py = div(ci, 2)
    Map.put(champ, :posn, [py, px])
  end 

  def apply_orders(battle) do
    orders = battle.orders
    battle = battle
    |> Map.put(:orders, [])
    |> Map.put(:events, [])
    Enum.reduce orders, battle, &apply_order/2
  end

  def apply_order([_player_id, champ_id, skill_id], battle) do
    champ   = get_champ(battle, champ_id)
    skill   = get_skill(champ, skill_id)
    effects = get_effects(skill)

    events = Enum.reduce effects, get_events(battle), fn eff, evts ->
      targs = pick_targets(battle, champ, eff)
      Enum.reduce targs, evts, fn tt, acc ->
        event = [tt.id, champ_id, eff]
        [ event | acc ]
      end
    end

    put_events(battle, events)
  end

  def get_effects(skill) do
    Map.get(skill.rules, "active")
    |> Bezoar.Util.keys_to_atom
  end

  def get_events(battle) do
    Bezoar.Util.keys_to_atom(battle.events)
  end

  def put_events(battle, events) do
    %{ battle | events: Bezoar.Util.keys_to_string(events) }
  end

  def get_champ(battle, champ_id) do
    Enum.find(battle.champs, fn cc -> cc.id == champ_id end)
  end

  def put_champ(battle, champ) do
    champs = Enum.map battle.champs, fn cc ->
      if champ.id == cc.id do
        champ
      else
        cc
      end
    end
    Map.put(battle, :champs, champs)
  end

  def get_skill(champ, skill_id) do
    Enum.find(champ.skills, fn ss -> ss.id == skill_id end)
  end

  def pick_targets(battle, champ, effect) do
    targs = battle.champs
    |> filter_in_range(champ, effect)
    |> filter_target_team(champ, effect)

    nn = Map.get(effect, :targs, 1)

    case effect.pick do
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
    Enum.sort_by champs, fn tt ->
      tt.hp / tt.hp_max
    end
  end

  def champ_distance(ch0, ch1) do
    [y0, x0] = ch0.posn
    [y1, x1] = ch1.posn
    abs(y1 - y0) + abs(x1 - x0)
  end

  def filter_in_range(targs, champ, effect) do
    Enum.filter targs, fn cc ->
      champ_distance(champ, cc) <= effect.range
    end
  end

  def filter_target_team(targs, champ, effect) do
    Enum.filter targs, fn cc ->
      case effect.team do
        "ally" ->
          champ.player_id == cc.player_id
        "enemy" -> 
          champ.player_id != cc.player_id
        "any" ->
          true
      end
    end
  end
end
