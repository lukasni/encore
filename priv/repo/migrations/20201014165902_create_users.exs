defmodule Encore.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :main_character_id, :integer
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
