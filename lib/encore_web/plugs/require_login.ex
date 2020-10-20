defmodule EncoreWeb.Plugs.RequireLogin do
  @moduledoc false

  alias EncoreWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: Routes.auth_path(conn, :new))
        |> Plug.Conn.halt()

      _user ->
        conn
    end
  end
end
