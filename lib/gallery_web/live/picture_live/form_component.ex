defmodule GalleryWeb.PictureLive.FormComponent do
  use GalleryWeb, :live_component

  alias Gallery.Art
  alias Gallery.Art.Picture

  @impl true
  def mount(socket) do
    File.mkdir_p!("priv/static/uploads")

    {:ok, allow_upload(socket, :photo, accept: ~w(.png .jpg .jpeg), max_entries: 3)}
  end

  @impl true
  def update(%{picture: picture} = assigns, socket) do
    changeset = Art.change_picture(picture)

    socket =
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", _params, socket) do

    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    picture = put_photo_url(socket, %Picture{})

    case Art.create_picture(picture, %{}, &consume_photo(socket, &1)) do
      {:ok, _picture} ->
        {:noreply,
         socket
         |> put_flash(:info, "Picture created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end

  # defp save_picture(socket, :edit, picture_params) do
  #   case Art.update_picture(socket.assigns.picture, picture_params) do
  #     {:ok, _picture} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Picture updated successfully")
  #        |> push_redirect(to: socket.assigns.return_to)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, :changeset, changeset)}
  #   end
  # end

  # defp save_picture(socket, :new, picture_params) do
  #   case Art.create_picture(picture_params) do
  #     {:ok, _picture} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Picture created successfully")
  #        |> push_redirect(to: socket.assigns.return_to)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, changeset: changeset)}
  #   end
  # end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  defp put_photo_url(socket, %Picture{} = picture) do

    {completed, []} = uploaded_entries(socket, :photo)

    urls =
      for entry <- completed do
        Routes.static_path(socket, "/uploads/#{entry.uuid}.#{ext(entry)}")
      end


    %Picture{picture | url: Enum.join(urls, ",")}
  end

  def consume_photo(socket, %Picture{} = picture) do
    consume_uploaded_entries(socket, :photo, fn meta, entry ->
      dest = Path.join("priv/static/uploads", "#{entry.uuid}.#{ext(entry)}")
      File.cp!(meta.path, dest)
    end)

    {:ok, picture}
  end
end
