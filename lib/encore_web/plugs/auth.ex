defmodule EncoreWeb.Plugs.Auth do
  @moduledoc false

  alias Encore.SSO

  def init(opts), do: opts

  def call(conn, _) do
    user_id = Plug.Conn.get_session(conn, :user_id)

    cond do
      conn.assigns[:current_user] ->
        conn

      user = user_id && Encore.Auth.get_user(user_id) ->
        Plug.Conn.assign(conn, :current_user, user)

      true ->
        conn
        |> Plug.Conn.assign(:current_user, nil)
        |> Plug.Conn.delete_session(:user_id)
    end
  end

  def do_login(conn, client) do
    with {:ok, verify} <- SSO.verify(client.token),
         {:ok, user} <- Encore.Auth.get_or_create_user(verify) do
      conn
      |> Phoenix.Controller.put_flash(:info, "Successfully logged in as #{user.main_character.name}")
      |> Plug.Conn.put_session(:user_id, user.id)
      |> Plug.Conn.assign(:current_user, user)
    else
      {:error, error} ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Error logging in: #{inspect error}")
    end
  end

  def do_logout(conn) do
    conn
    |> Plug.Conn.assign(:current_user, nil)
    |> Plug.Conn.configure_session(drop: true)
  end
end
