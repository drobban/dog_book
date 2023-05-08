defmodule DogBookWeb.DogLiveTest do
  use DogBookWeb.ConnCase

  import Phoenix.LiveViewTest
  import DogBook.DataFixtures

  @create_attrs %{
    birth_date: "2023-05-07",
    breed_specific: :bobtail,
    coat: :short,
    gender: :male,
    name: "some name",
    observe: true,
    partial: true,
    size: :normal,
    testicle_status: :ok
  }
  @update_attrs %{
    birth_date: "2023-05-08",
    breed_specific: :docked,
    coat: :long,
    gender: :female,
    name: "some updated name",
    observe: false,
    partial: false,
    size: :dwarf,
    testicle_status: :cryptochid
  }
  @invalid_attrs %{
    birth_date: nil,
    breed_specific: nil,
    coat: nil,
    gender: nil,
    name: nil,
    observe: false,
    partial: false,
    size: nil,
    testicle_status: nil
  }

  defp create_dog(_) do
    dog = dog_fixture()
    %{dog: dog}
  end

  describe "Index" do
    setup [:create_dog]

    test "lists all dogs", %{conn: conn, dog: dog} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/dogs")

      assert html =~ "Listing Dogs"
      assert html =~ dog.name
    end

    test "saves new dog", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/dogs")

      assert index_live |> element("a", "New Dog") |> render_click() =~
               "New Dog"

      assert_patch(index_live, ~p"/admin/dogs/new")

      assert index_live
             |> form("#dog-form", dog: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#dog-form", dog: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/dogs")

      html = render(index_live)
      assert html =~ "Dog created successfully"
      assert html =~ "some name"
    end

    test "updates dog in listing", %{conn: conn, dog: dog} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/dogs")

      assert index_live |> element("#dogs-#{dog.id} a", "Edit") |> render_click() =~
               "Edit Dog"

      assert_patch(index_live, ~p"/admin/dogs/#{dog}/edit")

      assert index_live
             |> form("#dog-form", dog: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#dog-form", dog: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/dogs")

      html = render(index_live)
      assert html =~ "Dog updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes dog in listing", %{conn: conn, dog: dog} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/dogs")

      assert index_live |> element("#dogs-#{dog.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#dogs-#{dog.id}")
    end
  end

  describe "Show" do
    setup [:create_dog]

    test "displays dog", %{conn: conn, dog: dog} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/dogs/#{dog}")

      assert html =~ "Show Dog"
      assert html =~ dog.name
    end

    test "updates dog within modal", %{conn: conn, dog: dog} do
      {:ok, show_live, _html} = live(conn, ~p"/admin/dogs/#{dog}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Dog"

      assert_patch(show_live, ~p"/admin/dogs/#{dog}/show/edit")

      assert show_live
             |> form("#dog-form", dog: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#dog-form", dog: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/admin/dogs/#{dog}")

      html = render(show_live)
      assert html =~ "Dog updated successfully"
      assert html =~ "some updated name"
    end
  end
end
