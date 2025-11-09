defmodule Elixirator.Repo do
  use Ecto.Repo,
    otp_app: :elixirator,
    adapter: Ecto.Adapters.Postgres
end
