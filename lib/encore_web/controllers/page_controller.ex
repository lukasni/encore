defmodule EncoreWeb.PageController do
  use EncoreWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
