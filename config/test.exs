import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :simple_drop, SimpleDrop.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "simple_drop_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

is_ci = System.get_env("IS_CI")

if is_ci do
  config :simple_drop, SimpleDrop.Repo, hostname: "postgres"
end

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :simple_drop, SimpleDropWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "JV3r0oKWoSb4YmcmO39vpfaCoSr6U4c3f33rfsjbSnMIiUJnPI8FKz1lSFB4rxYp",
  server: false

# In test we don't send emails.
config :simple_drop, SimpleDrop.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :info

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
