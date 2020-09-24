defmodule Encore.Repo do
  use Ecto.Repo,
    otp_app: :encore,
    adapter: Ecto.Adapters.Postgres
end
