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
        changeset = validate_first_and_last(changeset, segment_changesets)
        updated_changesets = validate_segment_changesets(segment_changesets)
        put_change(changeset, :path, updated_changesets)
    end
  end

  defp validate_first_and_last(changeset, segment_changesets) when length(segment_changesets) == 0 do
    changeset
  end

  defp validate_first_and_last(changeset, segment_changesets) do
    first_type = segment_changesets |> List.first() |> Ecto.Changeset.get_field(:type)
    last_type = segment_changesets |> List.last() |> Ecto.Changeset.get_field(:type)

    changeset
    |> maybe_add_first_error(first_type)
    |> maybe_add_last_error(last_type)
  end

  defp maybe_add_first_error(changeset, :land) do
    add_error(changeset, :path, "First action must be launch")
  end
  defp maybe_add_first_error(changeset, _), do: changeset

  defp maybe_add_last_error(changeset, :launch) do
    add_error(changeset, :path, "Last action must be land")
  end
  defp maybe_add_last_error(changeset, _), do: changeset

  defp validate_segment_changesets([]), do: []

  defp validate_segment_changesets(segment_changesets) do
    segment_changesets
    |> Enum.with_index()
    |> Enum.map(fn {segment_changeset, index} ->
      current_type = Ecto.Changeset.get_field(segment_changeset, :type)
      current_planet = Ecto.Changeset.get_field(segment_changeset, :planet)

      segment_changeset
      |> validate_alternating_with_previous(
        index,
        segment_changesets,
        current_type
      )
      |> validate_planet_continuity_with_previous(
        index,
        segment_changesets,
        current_type,
        current_planet
      )
    end)
  end

  defp validate_alternating_with_previous(changeset, index, segment_changesets, current_type)
       when index > 0 do
    prev_changeset = Enum.at(segment_changesets, index - 1)
    prev_type = Ecto.Changeset.get_field(prev_changeset, :type)

    if prev_type == current_type do
      Ecto.Changeset.add_error(
        changeset,
        :type,
        "must alternate with previous action (previous was #{prev_type})"
      )
    else
      changeset
    end
  end
  defp validate_alternating_with_previous(changeset, _index, _segment_changesets, _type),
    do: changeset

  defp validate_planet_continuity_with_previous(
         changeset,
         index,
         segment_changesets,
         :launch,
         current_planet
       )
       when index > 0 do
    prev_changeset = Enum.at(segment_changesets, index - 1)
    prev_type = Ecto.Changeset.get_field(prev_changeset, :type)
    prev_planet = Ecto.Changeset.get_field(prev_changeset, :planet)

    if prev_type == :land && prev_planet && current_planet && prev_planet != current_planet do
      Ecto.Changeset.add_error(
        changeset,
        :planet,
        "must launch from #{prev_planet} (where you landed)"
      )
    else
      changeset
    end
  end
  defp validate_planet_continuity_with_previous(changeset, _index, _changesets, _type, _planet),
    do: changeset
end
