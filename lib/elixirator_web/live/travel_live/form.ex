defmodule ElixiratorWeb.TravelLive.Form do
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
            <div class="mb-4">
              <div class="flex flex-row gap-2 items-start">
                <div class="flex-1 [&_.fieldset]:mb-0">
                  <.input type="select" prompt="select action type" label="Action" options={[:launch, :land]} field={path_f[:type]}/>
                </div>
                <div class="flex-1 [&_.fieldset]:mb-0">
                  <.input type="select" prompt="select planet" label="Planet" options={Planets.get_planet_names()} field={path_f[:planet]}/>
                </div>
                <div class="pt-6">
                  <button
                    type="button"
                    name="travel[path_drop][]"
                    value={path_f.index}
                    phx-click={JS.dispatch("change")}
                    class="btn btn-error btn-soft btn-sm"
                    title="Remove Segment"
                  >
                    <.icon name="hero-x-mark" class="w-4 h-4" />
                  </button>
                </div>
              </div>
            </div>
          </.inputs_for>

          <p
            :for={msg <- @form[:path].errors}
            class="mt-1.5 mb-4 flex gap-2 items-center text-sm text-error"
          >
            <.icon name="hero-exclamation-circle" class="size-5" />
            {translate_error(msg)}
          </p>

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
          </div>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"travel" => travel_params}, socket) do
    changeset = Travels.change_travel(socket.assigns.travel, travel_params)
    fuel_required = calculate_fuel_required(changeset)
    socket = socket
      |> assign(fuel_required: fuel_required)
      |> assign_form(Map.put(changeset, :action, :validate))

    {:noreply, socket}
  end
  
  defp calculate_fuel_required(%Ecto.Changeset{} = changeset) do
    mass = Ecto.Changeset.get_field(changeset, :equipment_mass)
    path = Ecto.Changeset.get_field(changeset, :path)
    valid_path = Enum.filter(path, fn segment -> segment.planet && segment.type end)
    
    Travels.calculate_fuel_required(%{equipment_mass: mass, path: valid_path})
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
