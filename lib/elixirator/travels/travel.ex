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
    |> cast(attrs, []) 
    |> cast_embed(
      :path, 
      required: true, 
      sort_param: :path_sort,
      drop_param: :path_drop
    )
  end
end
