defmodule DogBookWeb.ColorLive.FormComponent do
  use DogBookWeb, :live_component

  alias DogBook.Meta

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage color records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="color-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:number]} type="number" label="Number" />
        <.input field={@form[:color]} type="text" label="Color" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Color</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{color: color} = assigns, socket) do
    changeset = Meta.change_color(color)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"color" => color_params}, socket) do
    changeset =
      socket.assigns.color
      |> Meta.change_color(color_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"color" => color_params}, socket) do
    save_color(socket, socket.assigns.action, color_params)
  end

  defp save_color(socket, :edit, color_params) do
    case Meta.update_color(socket.assigns.color, color_params) do
      {:ok, color} ->
        notify_parent({:saved, color})

        {:noreply,
         socket
         |> put_flash(:info, "Color updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_color(socket, :new, color_params) do
    case Meta.create_color(color_params) do
      {:ok, color} ->
        notify_parent({:saved, color})

        {:noreply,
         socket
         |> put_flash(:info, "Color created successfully")
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
