defmodule DogBookWeb.BreedLive.FormComponent do
  use DogBookWeb, :live_component

  alias DogBook.Meta

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage breed records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="breed-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:number]} type="number" label="Number" />
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:sbk_working_dog]} type="checkbox" label="Working dog breed" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Breed</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{breed: breed} = assigns, socket) do
    changeset = Meta.change_breed(breed)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"breed" => breed_params}, socket) do
    changeset =
      socket.assigns.breed
      |> Meta.change_breed(breed_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"breed" => breed_params}, socket) do
    save_breed(socket, socket.assigns.action, breed_params)
  end

  defp save_breed(socket, :edit, breed_params) do
    case Meta.update_breed(socket.assigns.breed, breed_params) do
      {:ok, breed} ->
        notify_parent({:saved, breed})

        {:noreply,
         socket
         |> put_flash(:info, "Breed updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_breed(socket, :new, breed_params) do
    case Meta.create_breed(breed_params) do
      {:ok, breed} ->
        notify_parent({:saved, breed})

        {:noreply,
         socket
         |> put_flash(:info, "Breed created successfully")
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
