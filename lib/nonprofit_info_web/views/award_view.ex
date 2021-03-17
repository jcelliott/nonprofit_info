defmodule NonprofitInfoWeb.AwardView do
  use NonprofitInfoWeb, :view
  alias NonprofitInfoWeb.{AwardView, OrganizationView}

  def render("index.json", %{awards: awards}) do
    %{data: render_many(awards, AwardView, "award.json")}
  end

  def render("show.json", %{award: award}) do
    %{data: render_one(award, AwardView, "award.json")}
  end

  def render("award.json", %{award: award}) do
    %{
      id: award.id,
      purpose: award.purpose,
      amount: award.amount,
      recipient: render_one(award.recipient, OrganizationView, "organization.json")
    }
  end
end
