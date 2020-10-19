defmodule Encore.Auth.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :client_id, :string
    field :client_secret, :string
    field :refresh_token, :string
    field :scopes, {:array, :string}
    field :character_id, :id

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:client_id, :client_secret, :refresh_token, :scopes])
    |> validate_required([:client_id, :client_secret, :refresh_token, :scopes])
  end
end
