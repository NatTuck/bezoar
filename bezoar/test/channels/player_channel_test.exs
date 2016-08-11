defmodule Bezoar.PlayerChannelTest do
  use Bezoar.ChannelCase

  alias Bezoar.PlayerChannel

  setup do
    bob = insert(:player) |> with_champs
    sue = insert(:player) |> with_champs

    {:ok, "joined", socket} =
      socket()
      |> subscribe_and_join(PlayerChannel, "players:#{bob.id}")

    {:ok, [socket: socket, players: [bob, sue]]}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end

  test "join a game, submit orders", %{socket: socket, players: [bob, sue]} do
    [ aa, bb | _ ] = bob.champs
    aa_ss = hd(aa.skills)
    bb_ss = hd(bb.skills)

    assert length(bob.champs) == 4
    assert length(sue.champs) == 4

    ref = push socket, "orders", [[aa.id, aa_ss.id], [bb.id, bb_ss.id]]
    assert_reply ref, :ok, battle

    champs = Map.get(battle, "champs")
    assert length(champs) == 8

    events = Map.get(battle, "events")
    assert length(events) == 8

    cc = hd(champs)
    assert Map.get(cc, "hp") == Map.get(cc, "hp_base") - 2

    IO.inspect battle
  end
end
