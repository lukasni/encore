defmodule Encore.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :is_active, :boolean, default: true

    belongs_to :main_character, EVE.Characters.Character
    has_many :owned_characters, Encore.Auth.OwnedCharacter

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:main_character_id, :is_active])
    |> validate_required([:main_character_id])
  end
end
