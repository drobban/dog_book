defmodule DogBookWeb.ChampionLive.Index do
  use DogBookWeb, :live_view

  alias DogBook.Meta
  alias DogBook.Meta.Champion

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :champions, Meta.list_champions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Champion")
    |> assign(:champion, Meta.get_champion!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Champion")
    |> assign(:champion, %Champion{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Champions")
    |> assign(:champion, nil)
  end

  @impl true
  def handle_info({DogBookWeb.ChampionLive.FormComponent, {:saved, champion}}, socket) do
    {:noreply, stream_insert(socket, :champions, champion)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    champion = Meta.get_champion!(id)
    {:ok, _} = Meta.delete_champion(champion)

    {:noreply, stream_delete(socket, :champions, champion)}
  end
end
