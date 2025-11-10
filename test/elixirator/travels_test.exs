defmodule Elixirator.TravelsTest do
  use ExUnit.Case, async: true
  
  alias Elixirator.Travels
  alias Elixirator.Travels.Travel
  alias Elixirator.Travels.Travel.Segment
  
  describe "calculate_fuel_required" do
    test "should calculate Apollo 11 mission fuel correctly" do
      segments = [
        %Segment{launch: :Earth, land: :Moon}, 
        %Segment{launch: :Moon, land: :Earth}
      ]
      travel = %Travel{equipment_mass: 28801, path: segments}

      assert Travels.calculate_fuel_required(travel) == 51898
    end
    
    test "should calculate Mars mission fuel correctly" do
      segments = [
        %Segment{launch: :Earth, land: :Mars},
        %Segment{launch: :Mars, land: :Earth}
      ]
      travel = %Travel{equipment_mass: 14606, path: segments}

      assert Travels.calculate_fuel_required(travel) == 33388
    end

    test "should calculate Passenger Ship mission fuel correctly" do
      segments = [
        %Segment{launch: :Earth, land: :Moon},
        %Segment{launch: :Moon, land: :Mars},
        %Segment{launch: :Mars, land: :Earth}
      ]
      travel = %Travel{equipment_mass: 75432, path: segments}

      assert Travels.calculate_fuel_required(travel) == 212161
    end
  end
end
