defmodule SimpleDrop.Repo do
  use Ecto.Repo,
    otp_app: :simple_drop,
    adapter: Ecto.Adapters.Postgres
end
