defmodule Elixirator.Travels.Travel.Segment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Elixirator.Planets
  alias Elixirator.Travels.Travel.Segment

  embedded_schema do
    field :launch, Ecto.Enum, values: Planets.get_planet_names()
    field :land, Ecto.Enum, values: Planets.get_planet_names()
  end

  @doc false
  def changeset(%Segment{} = point, attrs) do
    point
    |> cast(attrs, [:launch, :land])
    |> validate_required([:launch, :land])
  end
end
