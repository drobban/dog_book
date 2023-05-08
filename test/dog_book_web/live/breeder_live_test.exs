defmodule DogBookWeb.BreederLiveTest do
  use DogBookWeb.ConnCase

  import Phoenix.LiveViewTest
  import DogBook.MetaFixtures

  @create_attrs %{name: "some name", number: 42}
  @update_attrs %{name: "some updated name", number: 43}
  @invalid_attrs %{name: nil, number: nil}

  defp create_breeder(_) do
    breeder = breeder_fixture()
    %{breeder: breeder}
  end

  describe "Index" do
    setup [:create_breeder]

    test "lists all breeders", %{conn: conn, breeder: breeder} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/breeders")

      assert html =~ "Listing Breeders"
      assert html =~ breeder.name
    end

    test "saves new breeder", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/breeders")

      assert index_live |> element("a", "New Breeder") |> render_click() =~
               "New Breeder"

      assert_patch(index_live, ~p"/admin/breeders/new")

      assert index_live
             |> form("#breeder-form", breeder: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#breeder-form", breeder: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/breeders")

      html = render(index_live)
      assert html =~ "Breeder created successfully"
      assert html =~ "some name"
    end

    test "updates breeder in listing", %{conn: conn, breeder: breeder} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/breeders")

      assert index_live |> element("#breeders-#{breeder.id} a", "Edit") |> render_click() =~
               "Edit Breeder"

      assert_patch(index_live, ~p"/admin/breeders/#{breeder}/edit")

      assert index_live
             |> form("#breeder-form", breeder: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#breeder-form", breeder: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/breeders")

      html = render(index_live)
      assert html =~ "Breeder updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes breeder in listing", %{conn: conn, breeder: breeder} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/breeders")

      assert index_live |> element("#breeders-#{breeder.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#breeders-#{breeder.id}")
    end
  end

  describe "Show" do
    setup [:create_breeder]

    test "displays breeder", %{conn: conn, breeder: breeder} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/breeders/#{breeder}")

      assert html =~ "Show Breeder"
      assert html =~ breeder.name
    end

    test "updates breeder within modal", %{conn: conn, breeder: breeder} do
      {:ok, show_live, _html} = live(conn, ~p"/admin/breeders/#{breeder}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Breeder"

      assert_patch(show_live, ~p"/admin/breeders/#{breeder}/show/edit")

      assert show_live
             |> form("#breeder-form", breeder: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#breeder-form", breeder: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/admin/breeders/#{breeder}")

      html = render(show_live)
      assert html =~ "Breeder updated successfully"
      assert html =~ "some updated name"
    end
  end
end
