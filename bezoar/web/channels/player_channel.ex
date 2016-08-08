defmodule Bezoar.PlayerChannel do
  use Bezoar.Web, :channel

  alias Bezoar.Repo
  alias Bezoar.Player

  def join("players:" <> player_id, payload, socket) do
    if authorized?(payload) do
      {:ok, pid} = Bezoar.Battle.start_link
      socket = Phoenix.Socket.assign(socket, :pid, pid)

      :ok = Bezoar.Battle.join(pid, player_id)
      {:ok, "joined", socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("get_state", _payload, socket) do
    {:reply, {:state, Bezoar.Battle.new}, socket}
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
