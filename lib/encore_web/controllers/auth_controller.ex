defmodule EncoreWeb.AuthController do
  use EncoreWeb, :controller

  alias Encore.SSO
  alias EncoreWeb.Plugs.Auth

  def login(conn, _params) do
    nonce = SSO.generate_nonce()
    uri =
      SSO.authorize_url!(
        state: nonce
      )

    conn
    |> put_session(:sso_state, nonce)
    |> put_session(:sso_action, :login)
    |> render("login.html", uri: uri)
  end

  def grant_scopes(conn, %{"scopes" => scopes}) do
    selected_scopes = MapSet.new(scopes)
    auth_scopes =
      for scope <- SSO.all_scopes(), scope.required == true, into: MapSet.new() do
        scope.scope
      end
      |> MapSet.union(selected_scopes)
      |> MapSet.delete("none")

    nonce = SSO.generate_nonce()
    uri = SSO.authorize_url!(
      state: nonce,
      scope: Enum.join(auth_scopes, " ")
    )

    conn
    |> put_session(:scope_selection, scopes)
    |> put_session(:sso_state, nonce)
    |> put_session(:sso_action, {:grant, auth_scopes})
    |> put_flash(:info, "Logging in with scopes #{inspect auth_scopes}")
    |> redirect(external: uri)
  end

  def grant_scopes(conn, _params) do
    scopes =
      SSO.all_scopes()
      |> Enum.reject(&is_nil(&1[:usage]))
      |> Enum.sort_by(& &1[:scope])

    scope_selection = get_session(conn, :scope_selection) || Enum.map(scopes, & &1[:scope])

    conn
    |> put_flash(:info, "#{inspect get_session(conn)}")
    |> render("grant_scopes.html", scopes: scopes, selected: scope_selection)
  end

  def callback(conn, %{"code" => code, "state" => state}) do
    with {:ok, _state} <- verify_nonce(conn, state),
         {:ok, client} <- SSO.get_token(code: code) do
      handle_callback(conn, client)
    end
  end

  defp handle_callback(conn, oauth2_client) do
    case get_session(conn, :sso_action) do
      :login ->
        conn
        |> Auth.clean_session()
        |> Auth.do_login(oauth2_client)
        |> redirect(to: Routes.page_path(conn, :index))

      {:grant, scopes} ->
        case SSO.verify(scopes, oauth2_client) do
          {:ok, _verified} ->
            conn
            |> Auth.clean_session()
            |> put_flash(:info, "Successfully authorized scopes #{inspect scopes}")
            |> redirect(to: Routes.page_path(conn, :index))

          {:error, _} ->
            conn
            |> Auth.clean_session()
            |> put_flash(:info, "Granted scopes don't match expected set.")
            |> redirect(to: Routes.auth_path(conn, :grant_scopes))
        end
    end
  end

  defp verify_nonce(conn, state) do
    if get_session(conn, :sso_state) == state do
      {:ok, state}
    else
      {:error, :invalid_state}
    end
  end
end
