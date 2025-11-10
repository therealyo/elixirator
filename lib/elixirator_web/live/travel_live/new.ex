defmodule ElixiratorWeb.TravelLive.New do
  use ElixiratorWeb, :live_view

  require Logger

  alias Elixirator.Travels  
  alias Elixirator.Planets  
  alias Elixirator.Travels.Travel
  
  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    travel = %Travel{}
    socket = socket 
      |> assign(travel: travel, fuel_required: 0) 
      |> assign_form(Travels.change_travel(travel))

    {:ok, socket}
  end
  
  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="bg-base-100 text-base-content p-6 rounded-lg shadow [[data-theme=dark]_&]:bg-zinc-900">
        <.form 
          for={@form}
          class="bg-base-100 text-base-content p-6 [[data-theme=dark]_&]:bg-zinc-900"
          phx-change="validate"
          phx-submit="save"
        >
          <.input type="number" label="Equipment Mass"  field={@form[:equipment_mass]}/>
          <.inputs_for :let={path_f} field={@form[:path]}>
            <input type="hidden" name="travel[path_sort][]" value={path_f.index} />
            <.input type="select" prompt="select launch point" label="Launch" options={Planets.get_planet_names()} field={path_f[:launch]}/>
            <.input type="select" prompt="select landing point" label="Land" options={Planets.get_planet_names()} field={path_f[:land]}/>
            <button
              type="button"
              name="travel[path_drop][]"
              value={path_f.index}
              phx-click={JS.dispatch("change")}
              class="btn btn-error btn-soft btn-sm"
              title="Remove Point"
            >
              <.icon name="hero-x-mark" class="w-4 h-4" />
            </button>
          </.inputs_for>
          
          <input type="hidden" name="travel[path_drop][]" />
          <button
            type="button"
            name="travel[path_sort][]"
            value="new"
            phx-click={JS.dispatch("change")}
            class="btn btn-primary btn-soft"
          >
            <.icon name="hero-plus" class="w-4 h-4 mr-2" /> Add Segment 
          </button>
          
          <div class="flex justify-between pt-6">
            <p>
              Fuel Required: {@fuel_required}
            </p>
            <.button type="submit" phx-disable-with="Saving...">
              Save Travel
            </.button>
          </div>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"travel" => travel_params}, socket) do
    changeset = Travels.change_travel(socket.assigns.travel, travel_params)
    socket = socket 
      |> assign_form(Map.put(changeset, :action, :validate)) 
    
    {:noreply, socket}
  end
  
  def handle_event("save", params, socket) do
    {:noreply, socket}
  end


  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "travel")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
