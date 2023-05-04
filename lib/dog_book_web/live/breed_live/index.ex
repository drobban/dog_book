defmodule DogBookWeb.BreedLive.Index do
  use DogBookWeb, :live_view

  alias DogBook.Meta
  alias DogBook.Meta.Breed

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :breeds, Meta.list_breeds())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Breed")
    |> assign(:breed, Meta.get_breed!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Breed")
    |> assign(:breed, %Breed{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Breeds")
    |> assign(:breed, nil)
  end

  @impl true
  def handle_info({DogBookWeb.BreedLive.FormComponent, {:saved, breed}}, socket) do
    {:noreply, stream_insert(socket, :breeds, breed)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    breed = Meta.get_breed!(id)
    {:ok, _} = Meta.delete_breed(breed)

    {:noreply, stream_delete(socket, :breeds, breed)}
  end
end
