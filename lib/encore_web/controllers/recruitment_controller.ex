defmodule EncoreWeb.RecruitmentController do
  use EncoreWeb, :controller

  alias Encore.Recruitment

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def apply(conn, _params) do
    conn
    |> assign(:steps, Recruitment.steps())
    |> render("apply.html")
  end
end
