defmodule Encore.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :client_id, :string
      add :client_secret, :string
      add :refresh_token, :string
      add :scopes, {:array, :string}
      add :character_id, references(:characters, on_delete: :delete_all)

      timestamps()
    end

    create index(:tokens, [:character_id])
  end
end
