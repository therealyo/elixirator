defmodule Elixirator.Travels do
  alias Elixirator.Travels.Travel
  alias Elixirator.Planets

  require Logger
  
  def calculate_fuel_required(%Travel{equipment_mass: mass, path: path}) do
    path 
    |> Enum.flat_map(fn s -> [%{type: :launch, planet: s.launch}, %{type: :land, planet: s.land}] end) 
    |> Enum.reverse()
    |> Enum.reduce(0, fn %{type: type, planet: planet}, acc -> 
      Logger.info([planet: planet])
      acc + Planets.calculate_fuel_required(mass + acc, planet, type)
    end)
  end

  def change_travel(%Travel{} = travel, attrs \\ %{}) do
    Travel.changeset(travel, attrs)
  end
end
