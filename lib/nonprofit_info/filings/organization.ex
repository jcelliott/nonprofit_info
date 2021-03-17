defmodule NonprofitInfo.Filings.Organization do
  use NonprofitInfo.Common.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :ein, :string
    field :name, :string
    field :address1, :string
    field :address2, :string
    field :city, :string
    field :state, :string
    field :zip_code, :string

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :ein, :address1, :address2, :city, :state, :zip_code])
    |> validate_required([:name, :ein, :address1, :city, :state, :zip_code])
  end
end
