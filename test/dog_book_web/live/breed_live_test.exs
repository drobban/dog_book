defmodule DogBookWeb.BreedLiveTest do
  use DogBookWeb.ConnCase

  import Phoenix.LiveViewTest
  import DogBook.MetaFixtures

  @create_attrs %{name: "some name", number: 42}
  @update_attrs %{name: "some updated name", number: 43}
  @invalid_attrs %{name: nil, number: nil}

  defp create_breed(_) do
    breed = breed_fixture()
    %{breed: breed}
  end

  describe "Index" do
    setup [:create_breed]

    test "lists all breeds", %{conn: conn, breed: breed} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/breeds")

      assert html =~ "Listing Breeds"
      assert html =~ breed.name
    end

    test "saves new breed", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/breeds")

      assert index_live |> element("a", "New Breed") |> render_click() =~
               "New Breed"

      assert_patch(index_live, ~p"/admin/breeds/new")

      assert index_live
             |> form("#breed-form", breed: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#breed-form", breed: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/breeds")

      html = render(index_live)
      assert html =~ "Breed created successfully"
      assert html =~ "some name"
    end

    test "updates breed in listing", %{conn: conn, breed: breed} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/breeds")

      assert index_live |> element("#breeds-#{breed.id} a", "Edit") |> render_click() =~
               "Edit Breed"

      assert_patch(index_live, ~p"/admin/breeds/#{breed}/edit")

      assert index_live
             |> form("#breed-form", breed: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#breed-form", breed: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/breeds")

      html = render(index_live)
      assert html =~ "Breed updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes breed in listing", %{conn: conn, breed: breed} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/breeds")

      assert index_live |> element("#breeds-#{breed.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#breeds-#{breed.id}")
    end
  end

  describe "Show" do
    setup [:create_breed]

    test "displays breed", %{conn: conn, breed: breed} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/breeds/#{breed}")

      assert html =~ "Show Breed"
      assert html =~ breed.name
    end

    test "updates breed within modal", %{conn: conn, breed: breed} do
      {:ok, show_live, _html} = live(conn, ~p"/admin/breeds/#{breed}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Breed"

      assert_patch(show_live, ~p"/admin/breeds/#{breed}/show/edit")

      assert show_live
             |> form("#breed-form", breed: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#breed-form", breed: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/admin/breeds/#{breed}")

      html = render(show_live)
      assert html =~ "Breed updated successfully"
      assert html =~ "some updated name"
    end
  end
end
