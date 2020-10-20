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

  def get_owned_characters(user) do
    from(
      oc in OwnedCharacter,
      join: c in assoc(oc, :character),
      where: oc.user_id == ^user.id,
      preload: [character: c]
    )
    |> Repo.all()
  end

  def add_grant_for_user(user, client, verify) do
    character =
      case EVE.Characters.get_character(verify["character_id"]) do
        nil ->
          {:ok, character} = EVE.Characters.create_character(%{id: verify["character_id"], name: verify["name"]})
          character

        character ->
          character
      end

    changes =
      case Repo.get(OwnedCharacter, verify["owner"]) do
        nil ->
          # create new grant
          user
          |> Ecto.build_assoc(:owned_characters)
          |> OwnedCharacter.changeset(
            %{
              owner_hash: verify["owner"],
              refresh_token: client.token.refresh_token,
              scopes: verify["scp"],
              character_id: character.id
            }
          )

        %OwnedCharacter{} = oc ->
          # update existing grant with new scopes
          oc
          |> OwnedCharacter.changeset(%{
            refresh_token: client.token.refresh_token,
            #client_id: client.client_id,
            #client_secret: client.client_secret,
            scopes: merge_scopes(oc, verify["scp"])
          })
      end

    Repo.insert_or_update(changes)
  end

  def merge_scopes(owned_character, new_scopes) when is_list(new_scopes) do
    merge_scopes(owned_character, MapSet.new(new_scopes))
  end

  def merge_scopes(owned_character, %MapSet{} = new_scopes) do
    MapSet.union(owned_character.scopes, new_scopes)
  end
end
