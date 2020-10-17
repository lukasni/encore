defmodule Encore.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters, primary_key: false) do
      add :id, :integer, primary_key: true
      add :name, :string
      add :corporation_id, references(:corporations, on_delete: :restrict)

      timestamps()
    end

    create index(:characters, [:corporation_id])
  end
end
