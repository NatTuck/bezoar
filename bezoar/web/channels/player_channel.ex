defmodule Bezoar.PlayerChannel do
  use Bezoar.Web, :channel
  import Bezoar.Util, only: [keys_to_string: 1, keys_to_atom: 1]

  def join("players:" <> player_id, payload, socket) do
    player_id = Bezoar.Util.to_int(player_id)

    if authorized?(payload) do
      {:ok, bpid} = Bezoar.Battle.start_link
      
      socket = socket
      |> Phoenix.Socket.assign(:bpid, bpid)
      |> Phoenix.Socket.assign(:player_id, player_id)

      :ok = Bezoar.Battle.join(bpid, player_id)
      {:ok, "joined", socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("orders", payload, socket) do
    bpid      = socket.assigns.bpid
    player_id = socket.assigns.player_id
    battle    = keys_to_string(Bezoar.Battle.act(bpid, player_id, keys_to_atom(payload)))
    {:reply, :ok, socket}
  end

  def handle_in("ready", _payload, socket) do
    %{bpid: bpid, player_id: player_id} = socket.assigns
    battle = keys_to_string(Bezoar.Battle.get(bpid, player_id))
    {:reply, {:begin, battle}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (players:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
