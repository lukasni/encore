defmodule EncoreWeb.RecruitmentView do
  use EncoreWeb, :view

  alias Phoenix.HTML.Tag

  def status_title(status) do
    case status do
      :draft -> "Draft"
      _ -> "Unknown Status"
    end
  end

  def status_description(status) do
    case status do
      :draft ->
        """
        Your application is in draft status.
        You can add and remove content until you are happy with it.
        The file accessible to only yourself until you are ready to publish it.
        """
    end
  end

  def question_input(%{type: :text}) do
    ~E"""
    <textarea class="bg-white rounded border h-32 w-full px-3 pt-2 resize-y"></textarea>
    """
  end

  def question_input(%{type: {:checkbox, choices}}) do
    ~E"""
    <%= for choice <- choices do %>
    <label class="inline-block mr-2 sm:block cursor-pointer">
      <input type="checkbox">
      <%= choice %>
    </label>
    <% end %>
    """
  end

  def question_input(_) do
    ~E"""
    <input type="text" />
    """
  end
end
