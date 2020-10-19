defmodule EVE.Alliances.Alliance do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, []}
  schema "alliances" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(alliance, attrs) do
    alliance
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
