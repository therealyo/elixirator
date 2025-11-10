defmodule ElixiratorWeb.TravelLive.Index do
  use ElixiratorWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.button patch={~p"/travels/new"} title="New Travel">
        New Travel
      </.button>
      Should render table here, but we are not storing items
    </Layouts.app>
    """
  end
end
