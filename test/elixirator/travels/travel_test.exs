defmodule Elixirator.Travels.TravelTest do
  use ExUnit.Case, async: true

  alias Elixirator.Travels.Travel

  describe "changeset/2" do
    test "returns valid changeset with valid attributes" do
      attrs = %{
        "equipment_mass" => "1000",
        "path" => %{
          "0" => %{"type" => "launch", "planet" => "Earth"},
          "1" => %{"type" => "land", "planet" => "Moon"}
        }
      }

      changeset = Travel.changeset(%Travel{}, attrs)

      assert changeset.valid?
      assert Ecto.Changeset.get_field(changeset, :equipment_mass) == 1000
    end

    test "returns invalid changeset when equipment_mass is missing" do
      attrs = %{
        "path" => %{
          "0" => %{"type" => "launch", "planet" => "Earth"},
          "1" => %{"type" => "land", "planet" => "Moon"}
        }
      }

      changeset = Travel.changeset(%Travel{}, attrs)

      refute changeset.valid?
      assert %{equipment_mass: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns invalid changeset when equipment_mass is negative" do
      attrs = %{
        "equipment_mass" => "-100",
        "path" => %{
          "0" => %{"type" => "launch", "planet" => "Earth"},
          "1" => %{"type" => "land", "planet" => "Moon"}
        }
      }

      changeset = Travel.changeset(%Travel{}, attrs)

      refute changeset.valid?
      assert %{equipment_mass: ["must be greater than or equal to 0"]} = errors_on(changeset)
    end

    test "returns invalid changeset when path is missing" do
      attrs = %{"equipment_mass" => "1000"}

      changeset = Travel.changeset(%Travel{}, attrs)

      refute changeset.valid?
      assert %{path: ["can't be blank"]} = errors_on(changeset)
    end
  end

  describe "validate_path_continuity/1" do
    test "returns invalid changeset when first action is land" do
      attrs = %{
        "equipment_mass" => "1000",
        "path" => %{
          "0" => %{"type" => "land", "planet" => "Moon"},
          "1" => %{"type" => "launch", "planet" => "Moon"},
          "2" => %{"type" => "land", "planet" => "Moon"}
        }
      }

      changeset = Travel.changeset(%Travel{}, attrs)

      refute changeset.valid?
      assert %{path: ["First action must be launch"]} = errors_on(changeset)
    end

    test "returns invalid changeset when last action is launch" do
      attrs = %{
        "equipment_mass" => "1000",
        "path" => %{
          "0" => %{"type" => "launch", "planet" => "Earth"},
          "1" => %{"type" => "land", "planet" => "Moon"},
          "2" => %{"type" => "launch", "planet" => "Moon"}
        }
      }

      changeset = Travel.changeset(%Travel{}, attrs)

      refute changeset.valid?
      assert %{path: ["Last action must be land"]} = errors_on(changeset)
    end

    test "returns valid changeset when first action is launch and last is land" do
      attrs = %{
        "equipment_mass" => "1000",
        "path" => %{
          "0" => %{"type" => "launch", "planet" => "Earth"},
          "1" => %{"type" => "land", "planet" => "Moon"}
        }
      }

      changeset = Travel.changeset(%Travel{}, attrs)

      assert changeset.valid?
    end
    
    test "returns invalid changeset when consecutive launches" do
      attrs = %{
        "equipment_mass" => "1000",
        "path" => %{
          "0" => %{"type" => "launch", "planet" => "Earth"},
          "1" => %{"type" => "launch", "planet" => "Moon"},
          "2" => %{"type" => "land", "planet" => "Mars"}
        }
      }

      changeset = Travel.changeset(%Travel{}, attrs)

      refute changeset.valid?

      path_changesets = Ecto.Changeset.get_change(changeset, :path)
      second_segment = Enum.at(path_changesets, 1)

      assert second_segment.errors == [
               type: {"must alternate with previous action (previous was launch)", []}
             ]
    end

    test "returns invalid changeset when consecutive lands" do
      attrs = %{
        "equipment_mass" => "1000",
        "path" => %{
          "0" => %{"type" => "launch", "planet" => "Earth"},
          "1" => %{"type" => "land", "planet" => "Moon"},
          "2" => %{"type" => "land", "planet" => "Mars"}
        }
      }

      changeset = Travel.changeset(%Travel{}, attrs)

      refute changeset.valid?

      path_changesets = Ecto.Changeset.get_change(changeset, :path)
      third_segment = Enum.at(path_changesets, 2)

      assert third_segment.errors == [
               type: {"must alternate with previous action (previous was land)", []}
             ]
    end

    test "returns invalid changeset when launching from different planet than landed" do
      attrs = %{
        "equipment_mass" => "1000",
        "path" => %{
          "0" => %{"type" => "launch", "planet" => "Earth"},
          "1" => %{"type" => "land", "planet" => "Moon"},
          "2" => %{"type" => "launch", "planet" => "Mars"},
          "3" => %{"type" => "land", "planet" => "Earth"}
        }
      }

      changeset = Travel.changeset(%Travel{}, attrs)

      refute changeset.valid?

      path_changesets = Ecto.Changeset.get_change(changeset, :path)
      third_segment = Enum.at(path_changesets, 2)

      assert third_segment.errors == [
               planet: {"must launch from Moon (where you landed)", []}
             ]
    end

    test "returns valid changeset when launching from same planet you landed" do
      attrs = %{
        "equipment_mass" => "1000",
        "path" => %{
          "0" => %{"type" => "launch", "planet" => "Earth"},
          "1" => %{"type" => "land", "planet" => "Moon"},
          "2" => %{"type" => "launch", "planet" => "Moon"},
          "3" => %{"type" => "land", "planet" => "Earth"}
        }
      }

      changeset = Travel.changeset(%Travel{}, attrs)

      assert changeset.valid?
    end
    
    test "returns valid changeset for multi-planet journey" do
      attrs = %{
        "equipment_mass" => "75432",
        "path" => %{
          "0" => %{"type" => "launch", "planet" => "Earth"},
          "1" => %{"type" => "land", "planet" => "Moon"},
          "2" => %{"type" => "launch", "planet" => "Moon"},
          "3" => %{"type" => "land", "planet" => "Mars"},
          "4" => %{"type" => "launch", "planet" => "Mars"},
          "5" => %{"type" => "land", "planet" => "Earth"}
        }
      }

      changeset = Travel.changeset(%Travel{}, attrs)

      assert changeset.valid?
    end

    test "returns invalid changeset with empty path" do
      attrs = %{
        "equipment_mass" => "1000",
        "path" => %{}
      }

      changeset = Travel.changeset(%Travel{}, attrs)

      refute changeset.valid?
      assert %{path: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns valid changeset with round trip to same planet" do
      attrs = %{
        "equipment_mass" => "1000",
        "path" => %{
          "0" => %{"type" => "launch", "planet" => "Earth"},
          "1" => %{"type" => "land", "planet" => "Earth"}
        }
      }

      changeset = Travel.changeset(%Travel{}, attrs)

      assert changeset.valid?
    end
  end
  
  defp errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
