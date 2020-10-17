defmodule Encore.Repo.Migrations.CreateAlliances do
  use Ecto.Migration

  def change do
    create table(:alliances, primary_key: false) do
      add :id, :integer, primary_key: true
      add :name, :string

      timestamps()
    end

  end
end
