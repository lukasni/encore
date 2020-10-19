defmodule Encore.Auth.OwnedCharacter do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:owner_hash, :string, []}
  schema "owned_characters" do
    belongs_to :user, Encore.Auth.User, type: :binary_id
    belongs_to :character, EVE.Characters.Character

    timestamps()
  end

  @doc false
  def changeset(owned_character, attrs) do
    owned_character
    |> cast(attrs, [:owner_hash])
    |> validate_required([:owner_hash])
  end
end
