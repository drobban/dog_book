defmodule DogBookWeb.BreederLive.Show do
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
     |> assign(:breeder, Meta.get_breeder!(id))}
  end

  defp page_title(:show), do: "Show Breeder"
  defp page_title(:edit), do: "Edit Breeder"
end
