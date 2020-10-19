defmodule Encore.Auth.LoginAttempt do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "login_attempts" do
    field :scopes, Ecto.MapSet, type: :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(login_attempt, attrs) do
    login_attempt
    |> cast(attrs, [:type, :scopes])
    |> validate_required([:type, :scopes])
  end
end
