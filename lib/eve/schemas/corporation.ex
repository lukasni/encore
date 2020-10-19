defmodule EVE.Alliances.Corporation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, []}
  schema "corporations" do
    field :name, :string
    field :alliance_id, :id

    timestamps()
  end

  @doc false
  def changeset(corporation, attrs) do
    corporation
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
