defmodule Elixirator.Travels do
  alias Elixirator.Travels.Travel

  def change_travel(%Travel{} = travel, attrs \\ %{}) do
    Travel.changeset(travel, attrs)
  end
end
