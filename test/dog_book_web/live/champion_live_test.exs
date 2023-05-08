defmodule DogBookWeb.ChampionLiveTest do
  use DogBookWeb.ConnCase

  import Phoenix.LiveViewTest
  import DogBook.MetaFixtures

  @create_attrs %{champ_name: "some champ_name", number: 42}
  @update_attrs %{champ_name: "some updated champ_name", number: 43}
  @invalid_attrs %{champ_name: nil, number: nil}

  defp create_champion(_) do
    champion = champion_fixture()
    %{champion: champion}
  end

  describe "Index" do
    setup [:create_champion]

    test "lists all champions", %{conn: conn, champion: champion} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/champions")

      assert html =~ "Listing Champions"
      assert html =~ champion.champ_name
    end

    test "saves new champion", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/champions")

      assert index_live |> element("a", "New Champion") |> render_click() =~
               "New Champion"

      assert_patch(index_live, ~p"/admin/champions/new")

      assert index_live
             |> form("#champion-form", champion: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#champion-form", champion: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/champions")

      html = render(index_live)
      assert html =~ "Champion created successfully"
      assert html =~ "some champ_name"
    end

    test "updates champion in listing", %{conn: conn, champion: champion} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/champions")

      assert index_live |> element("#champions-#{champion.id} a", "Edit") |> render_click() =~
               "Edit Champion"

      assert_patch(index_live, ~p"/admin/champions/#{champion}/edit")

      assert index_live
             |> form("#champion-form", champion: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#champion-form", champion: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/champions")

      html = render(index_live)
      assert html =~ "Champion updated successfully"
      assert html =~ "some updated champ_name"
    end

    test "deletes champion in listing", %{conn: conn, champion: champion} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/champions")

      assert index_live |> element("#champions-#{champion.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#champions-#{champion.id}")
    end
  end

  describe "Show" do
    setup [:create_champion]

    test "displays champion", %{conn: conn, champion: champion} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/champions/#{champion}")

      assert html =~ "Show Champion"
      assert html =~ champion.champ_name
    end

    test "updates champion within modal", %{conn: conn, champion: champion} do
      {:ok, show_live, _html} = live(conn, ~p"/admin/champions/#{champion}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Champion"

      assert_patch(show_live, ~p"/admin/champions/#{champion}/show/edit")

      assert show_live
             |> form("#champion-form", champion: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#champion-form", champion: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/admin/champions/#{champion}")

      html = render(show_live)
      assert html =~ "Champion updated successfully"
      assert html =~ "some updated champ_name"
    end
  end
end
