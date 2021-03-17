defmodule NonprofitInfoWeb.FilingController do
  use NonprofitInfoWeb, :controller

  alias NonprofitInfo.Filings
  alias NonprofitInfo.Filings.Filing

  action_fallback NonprofitInfoWeb.FallbackController

  def index(conn, _params) do
    filings = Filings.list_filings()
    render(conn, "index.json", filings: filings)
  end

  def create(conn, %{"filing" => filing_params}) do
    with {:ok, %Filing{} = filing} <- Filings.create_filing(filing_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.filing_path(conn, :show, filing))
      |> render("show.json", filing: filing)
    end
  end

  def show(conn, %{"id" => id}) do
    filing = Filings.get_filing!(id)
    render(conn, "show.json", filing: filing)
  end

  def update(conn, %{"id" => id, "filing" => filing_params}) do
    filing = Filings.get_filing!(id)

    with {:ok, %Filing{} = filing} <- Filings.update_filing(filing, filing_params) do
      render(conn, "show.json", filing: filing)
    end
  end

  def delete(conn, %{"id" => id}) do
    filing = Filings.get_filing!(id)

    with {:ok, %Filing{}} <- Filings.delete_filing(filing) do
      send_resp(conn, :no_content, "")
    end
  end
end
