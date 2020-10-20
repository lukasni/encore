defmodule EncoreWeb.UserController do
  use EncoreWeb, :controller

  alias Encore.Auth

  plug EncoreWeb.Plugs.RequireLogin

  def show(conn, _params) do
    characters = Auth.get_owned_characters(conn.assigns.current_user)

    conn
    |> render("profile.html", characters: characters)
  end
end
