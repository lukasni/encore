defmodule EncoreWeb.AuthController do
  use EncoreWeb, :controller

  def login(conn, _params) do
    render(conn, "login.html")
  end
end