defmodule NonprofitInfoWeb.OrganizationController do
  use NonprofitInfoWeb, :controller

  alias NonprofitInfo.Filings
  alias NonprofitInfo.Filings.Organization

  action_fallback NonprofitInfoWeb.FallbackController

  def index(conn, _params) do
    organizations = Filings.list_organizations()
    render(conn, "index.json", organizations: organizations)
  end

  def create(conn, %{"organization" => organization_params}) do
    with {:ok, %Organization{} = organization} <- Filings.create_organization(organization_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.organization_path(conn, :show, organization))
      |> render("show.json", organization: organization)
    end
  end

  def show(conn, %{"id" => id}) do
    organization = Filings.get_organization!(id)
    render(conn, "show.json", organization: organization)
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    organization = Filings.get_organization!(id)

    with {:ok, %Organization{} = organization} <- Filings.update_organization(organization, organization_params) do
      render(conn, "show.json", organization: organization)
    end
  end

  def delete(conn, %{"id" => id}) do
    organization = Filings.get_organization!(id)

    with {:ok, %Organization{}} <- Filings.delete_organization(organization) do
      send_resp(conn, :no_content, "")
    end
  end
end
