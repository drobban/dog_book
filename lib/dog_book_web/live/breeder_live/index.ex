defmodule DogBookWeb.BreederLive.Index do
  use DogBookWeb, :live_view

  alias DogBook.Meta
  alias DogBook.Meta.Breeder

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :breeders, Meta.list_breeders())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Breeder")
    |> assign(:breeder, Meta.get_breeder!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Breeder")
    |> assign(:breeder, %Breeder{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Breeders")
    |> assign(:breeder, nil)
  end

  @impl true
  def handle_info({DogBookWeb.BreederLive.FormComponent, {:saved, breeder}}, socket) do
    {:noreply, stream_insert(socket, :breeders, breeder)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    breeder = Meta.get_breeder!(id)
    {:ok, _} = Meta.delete_breeder(breeder)

    {:noreply, stream_delete(socket, :breeders, breeder)}
  end
end
