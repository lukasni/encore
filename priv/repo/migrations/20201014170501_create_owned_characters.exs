defmodule Encore.Repo.Migrations.CreateOwnedCharacters do
  use Ecto.Migration

  def change do
    create table(:owned_characters) do
      add :owner_hash, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :character_id, references(:characters, on_delete: :nilify_all)

      timestamps()
    end

    create index(:owned_characters, [:user_id])
    create index(:owned_characters, [:character_id])
  end
end
