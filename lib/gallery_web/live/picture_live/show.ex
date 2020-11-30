defmodule GalleryWeb.PictureLive.Show do
  use GalleryWeb, :live_view

  alias Gallery.Art

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:picture, Art.get_picture!(id))}
  end

  defp page_title(:show), do: "Show Picture"
  defp page_title(:edit), do: "Edit Picture"
end
