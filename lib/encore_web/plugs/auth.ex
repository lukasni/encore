defmodule EncoreWeb.Plugs.Auth do
  @moduledoc false

  alias Encore.SSO

  def init(opts), do: opts

  def call(conn, _) do
    case Plug.Conn.get_session(conn, :user) do
      nil ->
        Plug.Conn.assign(conn, :current_user, nil)

      user ->
        conn
        |> Plug.Conn.assign(:current_user, %{name: user.name, avatar: "https://images.evetech.net/characters/#{user.id}/portrait?size=512"})
    end
  end

  def clean_session(conn) do
    conn
    |> Plug.Conn.delete_session(:sso_state)
    |> Plug.Conn.delete_session(:sso_action)
  end

  def do_login(conn, client) do
    case SSO.verify(client.token) do
      {:ok, verify} ->
        conn
        |> Phoenix.Controller.put_flash(:info, "Successfully loged in as #{verify["name"]}")
        |> Plug.Conn.put_session(:user, %{name: verify["name"], id: verify["character_id"]})

      {:error, error} ->
        conn
        |> Phoenix.Controller.put_flash(:error, inspect(error))
    end
  end
end
