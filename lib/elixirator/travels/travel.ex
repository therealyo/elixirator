defmodule Elixirator.Travels.Travel do
  use Ecto.Schema

  import Ecto.Changeset

  alias Elixirator.Travels.Travel.Segment
  alias Elixirator.Travels.Travel
  require Logger

  embedded_schema do
    field :equipment_mass, :integer
    embeds_many :path, Segment, on_replace: :delete
    
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
    |> validate_path_continuity()
  end

  def validate_path_continuity(changeset) do
    case Ecto.Changeset.get_change(changeset, :path) do
      nil ->
        changeset
      segment_changesets when is_list(segment_changesets) ->
        updated_changesets = validate_segment_changesets(segment_changesets)
        put_change(changeset, :path, updated_changesets)
    end
  end

  defp validate_segment_changesets(segment_changesets) do
    segment_changesets
    |> Enum.with_index()
    |> Enum.map(fn {segment_changeset, index} ->
      if index > 0 do
        prev_changeset = Enum.at(segment_changesets, index - 1)
        prev_land = Ecto.Changeset.get_field(prev_changeset, :land)
        current_launch = Ecto.Changeset.get_field(segment_changeset, :launch)

        if prev_land && current_launch && prev_land != current_launch do
          Ecto.Changeset.add_error(
            segment_changeset,
            :launch,
            "must match previous point's landing location (#{prev_land})"
          )
        else
         segment_changeset 
        end
      else
       segment_changeset 
      end
    end)
  end
end
