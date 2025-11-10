defmodule Elixirator.Travels.Travel.Segment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Elixirator.Planets
  alias Elixirator.Travels.Travel.Segment

  @primary_key false
  embedded_schema do
    field :type, Ecto.Enum, values: [:launch, :land]
    field :planet, Ecto.Enum, values: Planets.get_planet_names()
  end

  @doc false
  def changeset(%Segment{} = segment, attrs) do
    segment
    |> cast(attrs, [:type, :planet])
    |> validate_required([:type, :planet])
  end
end
