defmodule DogBookWeb.BreederLive.FormComponent do
  use DogBookWeb, :live_component

  alias DogBook.Meta

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage breeder records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="breeder-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:number]} type="number" label="Number" />
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Breeder</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{breeder: breeder} = assigns, socket) do
    changeset = Meta.change_breeder(breeder)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"breeder" => breeder_params}, socket) do
    changeset =
      socket.assigns.breeder
      |> Meta.change_breeder(breeder_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"breeder" => breeder_params}, socket) do
    save_breeder(socket, socket.assigns.action, breeder_params)
  end

  defp save_breeder(socket, :edit, breeder_params) do
    case Meta.update_breeder(socket.assigns.breeder, breeder_params) do
      {:ok, breeder} ->
        notify_parent({:saved, breeder})

        {:noreply,
         socket
         |> put_flash(:info, "Breeder updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_breeder(socket, :new, breeder_params) do
    case Meta.create_breeder(breeder_params) do
      {:ok, breeder} ->
        notify_parent({:saved, breeder})

        {:noreply,
         socket
         |> put_flash(:info, "Breeder created successfully")
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
