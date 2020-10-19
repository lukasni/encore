defmodule EVE.Characters do
  alias EVE.Characters.Character
  alias Encore.Repo

  import Ecto.Query

  def get_character(character_id) do
    Character
    |> Repo.get(character_id)
  end

  def create_character(opts) do
    %Character{}
    |> Character.changeset(opts)
    |> Repo.insert()
  end
end
