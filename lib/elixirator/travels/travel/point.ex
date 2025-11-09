defmodule Elixirator.Travels.Travel.Point do
  use Ecto.Schema
  import Ecto.Changeset

  alias Elixirator.Travels.Travel.Point

  embedded_schema do
  #   field :planet, Ecto.Enum, values: [:earth, :moon, :mars]
  #   field :action, Ecto.Enum, values: [:launch, :land]
    field :launch, Ecto.Enum, values: [:earth, :moon, :mars]
    field :land, Ecto.Enum, values: [:earth, :moon, :mars]
  end

  @doc false
  def changeset(%Point{} = point, attrs) do
    point
    |> cast(attrs, [:launch, :land])
    |> validate_required([:launch, :land])
  end
end
