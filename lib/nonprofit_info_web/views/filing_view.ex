defmodule NonprofitInfoWeb.FilingView do
  use NonprofitInfoWeb, :view
  alias NonprofitInfoWeb.{AwardView, FilingView, OrganizationView}

  def render("index.json", %{filings: filings}) do
    %{data: render_many(filings, FilingView, "filing.json")}
  end

  def render("show.json", %{filing: filing}) do
    %{data: render_one(filing, FilingView, "filing.json")}
  end

  def render("filing.json", %{filing: filing}) do
    %{
      id: filing.id,
      tax_year: filing.tax_year,
      filer: render_one(filing.filer, OrganizationView, "organization.json"),
      awards: render_many(filing.awards, AwardView, "award.json")
    }
  end
end
