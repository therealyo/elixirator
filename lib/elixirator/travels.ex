defmodule Elixirator.Travels do
  alias Elixirator.Travels.Travel
  alias Elixirator.Planets

  require Logger
  
  def calculate_fuel_required(%{equipment_mass: mass, path: _path}) when is_nil(mass) do
    0
  end
  
  @doc """
  We calculate path in reverse, because we need to carry additional fuel
  """
  def calculate_fuel_required(%{equipment_mass: mass, path: path}) do
    path 
    |> Enum.reverse()
    |> Enum.reduce(0, fn %{type: type, planet: planet}, acc -> 
      acc + Planets.calculate_fuel_required(mass + acc, planet, type)
    end)
  end

  def change_travel(%Travel{} = travel, attrs \\ %{}) do
    Travel.changeset(travel, attrs)
  end
end
