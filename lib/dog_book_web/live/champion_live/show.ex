defmodule DogBookWeb.ChampionLive.Show do
  use DogBookWeb, :live_view

  alias DogBook.Meta

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:champion, Meta.get_champion!(id))}
  end

  defp page_title(:show), do: "Show Champion"
  defp page_title(:edit), do: "Edit Champion"
end
