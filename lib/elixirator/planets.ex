defmodule Elixirator.Planets do
  @planets %{
    Earth: %{gravity: 9.807},
    Moon: %{gravity: 1.62},
    Mars: %{gravity: 3.711}
  }
  require Logger

  @type action :: :land | :launch
  
  def get_planet_names(), do: [:Earth, :Moon, :Mars]
  
  def get_planets(), do: @planets
  
  def get_planet(planet) when is_atom(planet), do: @planets[planet] 
  
  @spec calculate_fuel_required(non_neg_integer(), atom(), action()) :: non_neg_integer() 
  def calculate_fuel_required(mass, planet, type) 
    when is_atom(planet) and is_number(mass) and type in [:land, :launch] do
    calculate_fuel_required(mass, @planets[planet] , type, 0)
  end
  
  defp calculate_fuel_required(mass, _planet, _type, acc) when mass <= 0 do
    acc
  end
  
  defp calculate_fuel_required(mass, %{gravity: gravity} = planet, :launch, acc) do
    fuel = floor(mass * gravity * 0.042 - 33)
    calculate_fuel_required(fuel, planet, :launch, acc + max(fuel, 0))
  end
  
  defp calculate_fuel_required(mass, %{gravity: gravity} = planet, :land, acc) do
    fuel = floor(mass * gravity * 0.033 - 42)
    calculate_fuel_required(fuel, planet, :land, acc + max(fuel, 0))
  end
end
