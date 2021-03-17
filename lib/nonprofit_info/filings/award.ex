defmodule NonprofitInfo.Filings.Award do
  use NonprofitInfo.Common.Schema
  import Ecto.Changeset
  alias NonprofitInfo.Filings.{Filing, Organization}

  schema "awards" do
    field :amount, :integer
    field :purpose, :string
    belongs_to :filer, Organization
    belongs_to :recipient, Organization
    belongs_to :filing, Filing

    timestamps()
  end

  @doc false
  def changeset(award, attrs) do
    award
    |> cast(attrs, [:purpose, :amount, :filer_id, :recipient_id, :filing_id])
    |> validate_required([:purpose, :amount, :filer_id, :filing_id])
  end
end
