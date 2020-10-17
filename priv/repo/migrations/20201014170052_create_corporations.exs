defmodule Encore.Repo.Migrations.CreateCorporations do
  use Ecto.Migration

  def change do
    create table(:corporations, primary_key: false) do
      add :id, :integer, primary_key: true
      add :name, :string
      add :alliance_id, references(:alliances, on_delete: :nilify_all)

      timestamps()
    end

    create index(:corporations, [:alliance_id])
  end
end
