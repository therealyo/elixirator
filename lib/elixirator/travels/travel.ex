defmodule Elixirator.Travels.Travel do
  use Ecto.Schema
  import Ecto.Changeset
  alias Elixirator.Travels.Travel.Point
  embedded_schema do
    field :fuel_required, :integer, virtual: true 
    has_many :path, Point
  end
end
