defmodule Encore.Auth do
  alias Encore.Repo
  alias Encore.Auth.{LoginAttempt, OwnedCharacter, User}
  alias EVE.Characters.Character

  import Ecto.Query

  def create_login_attempt(:login) do
    %LoginAttempt{}
    |> LoginAttempt.changeset(%{type: "login", scopes: []})
    |> Repo.insert()
  end

  def create_login_attempt({:grant, scopes}) do
    %LoginAttempt{}
    |> LoginAttempt.changeset(%{type: "grant", scopes: scopes})
    |> Repo.insert()
  end

  def get_login_attempt!(id) do
    Repo.get!(LoginAttempt, id)
  end

  def delete_login_attempt(schema) do
    Repo.delete(schema)
  end

  def get_user(id) do
    from(
      u in User,
      join: mc in assoc(u, :main_character),
      where: u.id == ^id,
      preload: [main_character: mc]
    )
    |> Repo.one()
  end

  def get_or_create_user(verify) do
    case find_user_by_owner_hash(verify["owner"]) do
      %User{} = user ->
        {:ok, user}

      nil ->
        create_user(verify)
    end
  end

  def find_user_by_owner_hash(owner_hash) do
    from(
      u in User,
      join: o in assoc(u, :owned_characters),
      join: c in assoc(o, :character),
      join: mc in assoc(u, :main_character),
      where: o.owner_hash == ^owner_hash,
      preload: [main_character: mc, owned_characters: {o, character: c}]
    )
    |> Repo.one()
  end

  def create_user(verify) do
    character =
      case EVE.Characters.get_character(verify["character_id"]) do
        %Character{} = c ->
          c

        nil ->
          {:ok, char} = EVE.Characters.create_character(%{id: verify["character_id"], name: verify["name"]})
          char
      end

    %User{
      main_character: character,
      owned_characters: [
        %OwnedCharacter{
          owner_hash: verify["owner"],
          character: character
        }
      ]
    }
    |> Repo.insert()
  end
end
