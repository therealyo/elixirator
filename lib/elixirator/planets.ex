defmodule Elixirator.Planets do
  @planets %{
    earth: %{gravity: 9.807},
    moon: %{gravity: 1.62},
    mars: %{gravity: 3.711}
  }

  def get_planets(), do: @planets
  
end
