defmodule Encore.Repo.Migrations.CreateOwnedCharacters do
  use Ecto.Migration

  def change do
    create table(:owned_characters, primary_key: false) do
      add :owner_hash, :string, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :character_id, references(:characters, on_delete: :nilify_all)

      timestamps()
    end

    create index(:owned_characters, [:user_id])
    create index(:owned_characters, [:character_id])
  end
end
