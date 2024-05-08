defmodule ExSeedify.Repo do
  use Ecto.Repo,
    otp_app: :ex_seedify,
    adapter: Ecto.Adapters.Postgres
end
