defmodule ElixiratorWeb.TravelLive.New do
  use ElixiratorWeb, :live_view

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    {:ok, socket}
  end
  
  def render(assigns) do
    ~H"""
    <form
      class="bg-base-100 text-base-content p-6 rounded-lg shadow [[data-theme=dark]_&]:bg-zinc-900"
    >

      
    </form>
    """
  end
end
