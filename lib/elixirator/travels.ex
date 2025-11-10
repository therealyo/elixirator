defmodule Elixirator.Travels do
  alias Elixirator.Travels.Travel
  alias Elixirator.Planets

  require Logger
  
  def calculate_fuel_required(%{equipment_mass: mass, path: _path}) when is_nil(mass) do
    0
  end
  
  @doc """
  We calculate path in reverse, 
  because we need to carry additional fuel based on the remaining mass on each action

  If path is 

    %Segment{type: :launch, planet: :Earth},
    %Segment{type: :land, planet: :Moon}, 
    %Segment{type: :launch, planet: :Moon}, 
    %Segment{type: :land, planet: :Earth}

  Then on the last Earth land, we will have to calculate fuel only for equipment, because we will use 
  all additional fuel before that on other actions, but before that for launch from Moon, 
  we would carry extra fuel to achieve land on Earth, and so on
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
