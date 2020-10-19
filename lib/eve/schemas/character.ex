defmodule EVE.Characters.Character do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, []}
  schema "characters" do
    field :name, :string
    field :corporation_id, :id

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:id, :name])
    |> validate_required([:id, :name])
  end
end
