defmodule NonprofitInfo.Repo.Migrations.CreateAwards do
  use Ecto.Migration

  def change do
    create table(:awards) do
      add :purpose, :text
      add :amount, :integer
      add :filer_id, references(:organizations)
      add :recipient_id, references(:organizations)
      add :filing_id, references(:filings)

      timestamps()
    end

  end
end
