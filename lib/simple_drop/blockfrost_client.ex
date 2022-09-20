defmodule SimpleDrop.BlockfrostClient do
  use Tesla

  plug Tesla.Middleware.BaseUrl, base_url()

  plug Tesla.Middleware.Headers, [
    {"project_id", project_id()}
  ]

  plug Tesla.Middleware.JSON

  def is_address_delegator(address) do
    case delegators() do
      {:ok, %{body: delegators}} ->
        all_stake_keys =
          delegators
          |> Enum.map(&Map.get(&1, "address"))

        {:ok, %{body: body}} = address_info(address)
        Enum.member?(all_stake_keys, body["stake_address"])

      _ ->
        false
    end
  end

  def address_info(address) do
    get("addresses/#{address}")
  end

  def delegators() do
    # Hardcoded to Preview Jungle
    get("/pools/pool1lu942x5chr8uc9zjzltkrm8m2q7raqyuhsw8xplcg0sn77r9jzt/delegators")
  end

  def base_url() do
    Application.get_env(:simple_drop, SimpleDrop.BlockfrostClient)[:base_url]
  end

  defp project_id() do
    Application.get_env(:simple_drop, SimpleDrop.BlockfrostClient)[:project_id]
  end
end
