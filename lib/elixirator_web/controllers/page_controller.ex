defmodule ElixiratorWeb.PageController do
  use ElixiratorWeb, :controller

  def home(conn, _params) do
    # render(conn, :home)
    redirect(conn, to: "/travels")
  end
end
