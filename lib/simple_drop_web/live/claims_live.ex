defmodule SimpleDropWeb.ClaimsLive do
  use Phoenix.LiveView

  def mount(_, _, socket) do
    socket =
      assign(socket,
        address: nil,
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
          phx-change="set-address"
          autocomplete="off"
          phx-submit="save">

          <input  name="address" type="text" />
          <button type="submit" phx-disable-with="Saving...">Check</button>
        </form>
      <% end %>
    <% end %>
    """
  end

  def handle_event("set-address", %{"address" => address}, socket) do
    socket = assign(socket, :address, address)
    {:noreply, socket}
  end

  def handle_event("save", _, socket) do
    send(self(), :check_rewards)
    socket = assign(socket, :is_checking_rewards, true)

    {:noreply, socket}
  end

  def handle_info(:check_rewards, socket) do
    address = socket.assigns.address
    is_delegated = check_presence_of_delegator(address)

    socket =
      assign(socket,
        is_delegated: is_delegated,
        is_checking_rewards: false,
        has_checked_rewards: true
      )

    {:noreply, socket}
  end

  defp check_presence_of_delegator(base_address) do
    SimpleDrop.BlockfrostClient.is_address_delegator(base_address)
  end
end
