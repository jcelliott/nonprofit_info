defmodule NonprofitInfoWeb.AwardController do
  use NonprofitInfoWeb, :controller

  alias NonprofitInfo.Filings
  alias NonprofitInfo.Filings.Award

  action_fallback NonprofitInfoWeb.FallbackController

  def index(conn, params) do
    awards = Filings.list_awards(params)
    render(conn, "index.json", awards: awards)
  end

  def create(conn, %{"award" => award_params}) do
    with {:ok, %Award{} = award} <- Filings.create_award(award_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.award_path(conn, :show, award))
      |> render("show.json", award: award)
    end
  end

  def show(conn, %{"id" => id}) do
    award = Filings.get_award!(id)
    render(conn, "show.json", award: award)
  end

  def update(conn, %{"id" => id, "award" => award_params}) do
    award = Filings.get_award!(id)

    with {:ok, %Award{} = award} <- Filings.update_award(award, award_params) do
      render(conn, "show.json", award: award)
    end
  end

  def delete(conn, %{"id" => id}) do
    award = Filings.get_award!(id)

    with {:ok, %Award{}} <- Filings.delete_award(award) do
      send_resp(conn, :no_content, "")
    end
  end
end
