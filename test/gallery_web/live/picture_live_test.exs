defmodule GalleryWeb.PictureLiveTest do
  use GalleryWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Gallery.Art

  @create_attrs %{message: "some message"}
  @update_attrs %{message: "some updated message"}
  @invalid_attrs %{message: nil}

  defp fixture(:picture) do
    {:ok, picture} = Art.create_picture(@create_attrs)
    picture
  end

  defp create_picture(_) do
    picture = fixture(:picture)
    %{picture: picture}
  end

  describe "Index" do
    setup [:create_picture]

    test "lists all pictures", %{conn: conn, picture: picture} do
      {:ok, _index_live, html} = live(conn, Routes.picture_index_path(conn, :index))

      assert html =~ "Listing Pictures"
      assert html =~ picture.message
    end

    test "saves new picture", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.picture_index_path(conn, :index))

      assert index_live |> element("a", "New Picture") |> render_click() =~
               "New Picture"

      assert_patch(index_live, Routes.picture_index_path(conn, :new))

      assert index_live
             |> form("#picture-form", picture: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#picture-form", picture: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.picture_index_path(conn, :index))

      assert html =~ "Picture created successfully"
      assert html =~ "some message"
    end

    test "updates picture in listing", %{conn: conn, picture: picture} do
      {:ok, index_live, _html} = live(conn, Routes.picture_index_path(conn, :index))

      assert index_live |> element("#picture-#{picture.id} a", "Edit") |> render_click() =~
               "Edit Picture"

      assert_patch(index_live, Routes.picture_index_path(conn, :edit, picture))

      assert index_live
             |> form("#picture-form", picture: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#picture-form", picture: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.picture_index_path(conn, :index))

      assert html =~ "Picture updated successfully"
      assert html =~ "some updated message"
    end

    test "deletes picture in listing", %{conn: conn, picture: picture} do
      {:ok, index_live, _html} = live(conn, Routes.picture_index_path(conn, :index))

      assert index_live |> element("#picture-#{picture.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#picture-#{picture.id}")
    end
  end

  describe "Show" do
    setup [:create_picture]

    test "displays picture", %{conn: conn, picture: picture} do
      {:ok, _show_live, html} = live(conn, Routes.picture_show_path(conn, :show, picture))

      assert html =~ "Show Picture"
      assert html =~ picture.message
    end

    test "updates picture within modal", %{conn: conn, picture: picture} do
      {:ok, show_live, _html} = live(conn, Routes.picture_show_path(conn, :show, picture))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Picture"

      assert_patch(show_live, Routes.picture_show_path(conn, :edit, picture))

      assert show_live
             |> form("#picture-form", picture: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#picture-form", picture: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.picture_show_path(conn, :show, picture))

      assert html =~ "Picture updated successfully"
      assert html =~ "some updated message"
    end
  end
end
