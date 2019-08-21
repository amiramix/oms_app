defmodule OmsApi.Repo do
  use Ecto.Repo,
    otp_app: :oms_api,
    adapter: Ecto.Adapters.Postgres
end
