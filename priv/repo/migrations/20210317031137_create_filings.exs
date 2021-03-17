defmodule NonprofitInfo.Repo.Migrations.CreateFilings do
  use Ecto.Migration

  def change do
    create table(:filings) do
      add :tax_year, :integer
      add :filer_id, references(:organizations)

      timestamps()
    end

  end
end
