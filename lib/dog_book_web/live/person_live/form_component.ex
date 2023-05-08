defmodule DogBookWeb.PersonLive.FormComponent do
  use DogBookWeb, :live_component

  alias DogBook.Meta

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage person records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="person-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:street]} type="text" label="Street" />
        <.input field={@form[:zip_code]} type="number" label="Zip code" />
        <.input field={@form[:city]} type="text" label="City" />
        <.input field={@form[:phone]} type="text" label="Phone" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Person</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{person: person} = assigns, socket) do
    changeset = Meta.change_person(person)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset =
      socket.assigns.person
      |> Meta.change_person(person_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"person" => person_params}, socket) do
    save_person(socket, socket.assigns.action, person_params)
  end

  defp save_person(socket, :edit, person_params) do
    case Meta.update_person(socket.assigns.person, person_params) do
      {:ok, person} ->
        notify_parent({:saved, person})

        {:noreply,
         socket
         |> put_flash(:info, "Person updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_person(socket, :new, person_params) do
    case Meta.create_person(person_params) do
      {:ok, person} ->
        notify_parent({:saved, person})

        {:noreply,
         socket
         |> put_flash(:info, "Person created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
