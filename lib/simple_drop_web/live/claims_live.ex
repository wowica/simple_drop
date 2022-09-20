defmodule SimpleDropWeb.ClaimsLive do
  use Phoenix.LiveView

  def mount(_, _, socket) do
    socket =
      assign(socket,
        stake_key: nil,
        is_delegated: nil,
        is_checking_rewards: false,
        has_checked_rewards: false
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <%= if @is_checking_rewards do %>
      <p>
        <div class="loader"></div>
        <div class="loader-text">Checking your rewards</div>
      </p>
    <% else %>
      <%= if @has_checked_rewards do %>
        <%= if @is_delegated do %>
          You are eligible! 👏
        <% else %>
          Not eligible! 😢
        <% end %>
      <% else %>
        <form style="width: 500px"
          phx-change="banana"
          autocomplete="off"
          phx-submit="save">

          <input  name="stake-key" type="text" />
          <button type="submit" phx-disable-with="Saving...">Check</button>
        </form>
      <% end %>
    <% end %>
    """
  end

  def handle_event("banana", %{"stake-key" => stake_key}, socket) do
    socket = assign(socket, :stake_key, stake_key)
    {:noreply, socket}
  end

  def handle_event("save", _, socket) do
    send(self(), :check_rewards)
    socket = assign(socket, :is_checking_rewards, true)

    {:noreply, socket}
  end

  def handle_info(:check_rewards, socket) do
    stake_key = socket.assigns.stake_key
    is_delegated = check_presence_of_delegator(stake_key)

    socket =
      assign(socket,
        is_delegated: is_delegated,
        is_checking_rewards: false,
        has_checked_rewards: true
      )

    {:noreply, socket}
  end

  defp check_presence_of_delegator(address) do
    SimpleDrop.BlockfrostClient.is_address_delegator(address)
  end
end
