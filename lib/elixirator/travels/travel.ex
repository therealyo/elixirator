defmodule Elixirator.Travels.Travel do
  use Ecto.Schema

  import Ecto.Changeset

  alias Elixirator.Travels.Travel.Point
  alias Elixirator.Travels.Travel

  embedded_schema do
    field :equipment_mass, :integer
    embeds_many :path, Point, on_replace: :delete
    
    field :fuel_required, :integer, virtual: true
  end

  def changeset(%Travel{} = travel, attrs \\ %{}) do
    travel 
    |> cast(attrs, [:equipment_mass]) 
    |> cast_embed(
      :path, 
      required: true, 
      sort_param: :path_sort,
      drop_param: :path_drop
    )
    |> validate_required([:equipment_mass])
    |> validate_number(:equipment_mass, greater_than_or_equal_to: 0)
  end
end
