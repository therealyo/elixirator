defmodule Elixirator.TravelsTest do
  use ExUnit.Case, async: true
  
  alias Elixirator.Travels
  alias Elixirator.Travels.Travel
  alias Elixirator.Travels.Travel.Segment
  
  describe "calculate_fuel_required" do
    test "should calculate Apollo 11 mission fuel correctly" do
      path = [
        %Segment{type: :launch, planet: :Earth},
        %Segment{type: :land, planet: :Moon}, 
        %Segment{type: :launch, planet: :Moon}, 
        %Segment{type: :land, planet: :Earth}
      ]
      travel = %Travel{equipment_mass: 28801, path: path}

      assert Travels.calculate_fuel_required(travel) == 51898
    end
    
    test "should calculate Mars mission fuel correctly" do
      segments = [
        %Segment{type: :launch, planet: :Earth},
        %Segment{type: :land, planet: :Mars},
        %Segment{type: :launch, planet: :Mars},
        %Segment{type: :land, planet: :Earth}
      ]
      travel = %Travel{equipment_mass: 14606, path: segments}

      assert Travels.calculate_fuel_required(travel) == 33388
    end

    test "should calculate Passenger Ship mission fuel correctly" do
      segments = [
        %Segment{type: :launch, planet: :Earth},
        %Segment{type: :land, planet: :Moon},
        %Segment{type: :launch, planet: :Moon},
        %Segment{type: :land, planet: :Mars},
        %Segment{type: :launch, planet: :Mars},
        %Segment{type: :land, planet: :Earth}
      ]
      travel = %Travel{equipment_mass: 75432, path: segments}

      assert Travels.calculate_fuel_required(travel) == 212161
    end
  end
end
