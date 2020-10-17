defmodule Encore.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :is_active, :boolean, default: false
    field :main_character_id, :integer

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:main_character_id, :is_active])
    |> validate_required([:main_character_id, :is_active])
  end
end
