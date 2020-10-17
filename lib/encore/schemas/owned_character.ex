defmodule Encore.OwnedCharacter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "owned_characters" do
    field :owner_hash, :string
    field :user_id, :id
    field :character_id, :id

    timestamps()
  end

  @doc false
  def changeset(owned_character, attrs) do
    owned_character
    |> cast(attrs, [:owner_hash])
    |> validate_required([:owner_hash])
  end
end
