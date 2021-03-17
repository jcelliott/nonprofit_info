defmodule NonprofitInfo.Filings.Filing do
  use NonprofitInfo.Common.Schema
  import Ecto.Changeset
  alias NonprofitInfo.Filings.{Award, Organization}

  schema "filings" do
    field :tax_year, :integer
    belongs_to :filer, Organization
    has_many :awards, Award

    timestamps()
  end

  @doc false
  def changeset(filing, attrs) do
    filing
    |> cast(attrs, [:tax_year, :filer_id])
    |> validate_required([:tax_year, :filer_id])
    |> assoc_constraint(:filer)
    |> unique_constraint([:filer_id, :tax_year],
      message: "a filing for this organization and tax year already exists"
    )
  end
end
