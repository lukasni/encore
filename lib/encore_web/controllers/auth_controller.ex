defmodule EncoreWeb.AuthController do
  use EncoreWeb, :controller

  alias Encore.{SSO, Auth}
  alias Encore.Auth.User

  def new(conn, _params) do
    {:ok, attempt} = Auth.create_login_attempt(:login)
    uri =
      SSO.authorize_url!(
        state: attempt.id
      )

    conn
    |> render("login.html", uri: uri)
  end

  def delete(conn, _params) do
    conn
    |> EncoreWeb.Plugs.Auth.do_logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def grant_scopes(%{assigns: %{current_user: nil}} = conn, _params) do
    conn
    |> put_flash(:info, "You need to sign in before granting permissions")
    |> redirect(to: Routes.auth_path(conn, :login))
  end

  def grant_scopes(conn, %{"scopes" => scopes}) do
    selected_scopes = MapSet.new(scopes)
    auth_scopes =
      for scope <- SSO.all_scopes(), scope.required == true, into: MapSet.new() do
        scope.scope
      end
      |> MapSet.union(selected_scopes)
      |> MapSet.delete("none")

    {:ok, attempt} = Auth.create_login_attempt({:grant, auth_scopes})
    uri = SSO.authorize_url!(
      state: attempt.id,
      scope: Enum.join(auth_scopes, " ")
    )

    conn
    |> put_session(:scope_selection, scopes)
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
    |> render("grant_scopes.html", scopes: scopes, selected: scope_selection)
  end

  def callback(conn, %{"code" => code, "state" => state}) do
    with attempt <- Auth.get_login_attempt!(state),
         {:ok, client} <- SSO.get_token(code: code) do
      handle_callback(conn, attempt, client)
    end
  end

  def handle_callback(conn, %{type: "login"} = attempt, client) do
    Auth.delete_login_attempt(attempt)
    conn
    |> EncoreWeb.Plugs.Auth.do_login(client)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def handle_callback(%{assigns: %{current_user: %User{} = user}} = conn, %{type: "grant", scopes: scopes} = attempt, client) do
    Auth.delete_login_attempt(attempt)

    with {:ok, verified} <- SSO.verify(client, scopes),
         {:ok, oc} <- Auth.add_grant_for_user(user, client, verified) do
        conn
        |> put_flash(:info, "Successfully authorized scopes #{inspect oc}")
        |> redirect(to: Routes.page_path(conn, :index))
    else
      {:error, {:invalid_scopes, _actual}} ->
        conn
        |> put_flash(:error, "Granted scopes don't match expected set.")
        |> redirect(to: Routes.auth_path(conn, :grant_scopes))

      {:error, e} ->
        conn
        |> put_flash(:error, "An unexpected error occurred: #{inspect e}")
    end
  end
end
