defmodule NonprofitInfo.Repo.Migrations.AddFilingFilerTaxYearUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:filings, [:filer_id, :tax_year])
  end
end
