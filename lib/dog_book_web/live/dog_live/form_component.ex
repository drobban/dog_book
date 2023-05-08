defmodule DogBookWeb.DogLive.FormComponent do
  use DogBookWeb, :live_component

  alias DogBook.Data

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage dog records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="dog-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input
          field={@form[:gender]}
          type="select"
          label="Gender"
          prompt="Choose a value"
          options={Ecto.Enum.values(DogBook.Data.Dog, :gender)}
        />
        <.input field={@form[:birth_date]} type="date" label="Birth date" />
        <.input
          field={@form[:breed_specific]}
          type="select"
          label="Breed specific"
          prompt="Choose a value"
          options={Ecto.Enum.values(DogBook.Data.Dog, :breed_specific)}
        />
        <.input
          field={@form[:coat]}
          type="select"
          label="Coat"
          prompt="Choose a value"
          options={Ecto.Enum.values(DogBook.Data.Dog, :coat)}
        />
        <.input
          field={@form[:size]}
          type="select"
          label="Size"
          prompt="Choose a value"
          options={Ecto.Enum.values(DogBook.Data.Dog, :size)}
        />
        <.input field={@form[:observe]} type="checkbox" label="Observe" />
        <.input
          field={@form[:testicle_status]}
          type="select"
          label="Testicle status"
          prompt="Choose a value"
          options={Ecto.Enum.values(DogBook.Data.Dog, :testicle_status)}
        />
        <.input field={@form[:partial]} type="checkbox" label="Partial" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Dog</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{dog: dog} = assigns, socket) do
    changeset = Data.change_dog(dog)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"dog" => dog_params}, socket) do
    changeset =
      socket.assigns.dog
      |> Data.change_dog(dog_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"dog" => dog_params}, socket) do
    save_dog(socket, socket.assigns.action, dog_params)
  end

  defp save_dog(socket, :edit, dog_params) do
    case Data.update_dog(socket.assigns.dog, dog_params) do
      {:ok, dog} ->
        notify_parent({:saved, dog})

        {:noreply,
         socket
         |> put_flash(:info, "Dog updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_dog(socket, :new, dog_params) do
    case Data.create_dog(dog_params) do
      {:ok, dog} ->
        notify_parent({:saved, dog})

        {:noreply,
         socket
         |> put_flash(:info, "Dog created successfully")
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
