defmodule Elixirator.PlanetsTest do
  use ExUnit.Case, async: true

  alias Elixirator.Planets
  describe "calculate_fuel_required/3" do
    test "should calculate land fuel for Earth correctly" do
      equipment_mass = 28801
      assert Planets.calculate_fuel_required(equipment_mass, :Earth, :land) == 13447
    end

    test "should calculate launch fuel for Earth correctly" do
      equipment_mass = 28801
      assert Planets.calculate_fuel_required(equipment_mass, :Earth, :launch) == 19772
    end

    test "should return 0 for negative mass" do
      equipment_mass = -100
      assert Planets.calculate_fuel_required(equipment_mass, :Earth, :land) == 0
    end
  end
end
