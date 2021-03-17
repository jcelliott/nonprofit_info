defmodule NonprofitInfo.Repo.Migrations.AddEinUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:organizations, [:ein])
  end
end
