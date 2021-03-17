defmodule NonprofitInfoWeb.OrganizationView do
  use NonprofitInfoWeb, :view
  alias NonprofitInfoWeb.OrganizationView

  def render("index.json", %{organizations: organizations}) do
    %{data: render_many(organizations, OrganizationView, "organization.json")}
  end

  def render("show.json", %{organization: organization}) do
    %{data: render_one(organization, OrganizationView, "organization.json")}
  end

  def render("organization.json", %{organization: organization}) do
    %{id: organization.id,
      name: organization.name,
      ein: organization.ein,
      address1: organization.address1,
      address2: organization.address2,
      city: organization.city,
      state: organization.state,
      zip_code: organization.zip_code}
  end
end
