defmodule Bezoar.PlayerChannelTest do
  use Bezoar.ChannelCase

  alias Bezoar.PlayerChannel

  setup do
    bob = insert(:player)
    champs = Enum.map 1..4, fn _ ->
      insert(:champ, player: bob)
    end

    {:ok, battle, socket} =
      socket()
      |> subscribe_and_join(PlayerChannel, "players:#{bob.id}")

    {:ok, [socket: socket, champs: champs]}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end

  test "join a game, submit orders", %{socket: socket, champs: champs} do
    IO.inspect champs
  end
end
