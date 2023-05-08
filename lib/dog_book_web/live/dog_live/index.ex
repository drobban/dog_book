defmodule DogBookWeb.DogLive.Index do
  use DogBookWeb, :live_view

  alias DogBook.Data
  alias DogBook.Data.Dog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :dogs, Data.list_dogs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Dog")
    |> assign(:dog, Data.get_dog!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Dog")
    |> assign(:dog, %Dog{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Dogs")
    |> assign(:dog, nil)
  end

  @impl true
  def handle_info({DogBookWeb.DogLive.FormComponent, {:saved, dog}}, socket) do
    {:noreply, stream_insert(socket, :dogs, dog)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    dog = Data.get_dog!(id)
    {:ok, _} = Data.delete_dog(dog)

    {:noreply, stream_delete(socket, :dogs, dog)}
  end
end
