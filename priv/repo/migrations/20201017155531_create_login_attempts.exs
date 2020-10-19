defmodule Encore.Repo.Migrations.CreateLoginAttempts do
  use Ecto.Migration

  def change do
    create table(:login_attempts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :type, :string
      add :scopes, {:array, :string}

      timestamps()
    end

  end
end
