defmodule NonprofitInfo.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string
      add :ein, :string
      add :address1, :string
      add :address2, :string
      add :city, :string
      add :state, :string
      add :zip_code, :string

      timestamps()
    end

  end
end
