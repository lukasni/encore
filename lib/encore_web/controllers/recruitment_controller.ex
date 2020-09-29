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

  def my_application(conn, _params) do
    conn
    |> assign(:file, Recruitment.get_file(:example))
    |> render("application.html")
  end

  def questionnaire(conn, _params) do
    conn
    |> assign(:questionnaire, Recruitment.get_questionnaire())
    |> render("questionnaire.html")
  end

  def characters(conn, _params) do
    conn
    |> assign(:characters, Recruitment.get_file(:example)[:characters ])
    #|> assign(:characters, [])
    |> render("characters.html")
  end
end
