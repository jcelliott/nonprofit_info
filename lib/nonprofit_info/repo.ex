defmodule NonprofitInfo.Repo do
  use Ecto.Repo,
    otp_app: :nonprofit_info,
    adapter: Ecto.Adapters.Postgres
end
