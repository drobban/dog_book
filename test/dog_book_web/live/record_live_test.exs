defmodule DogBookWeb.RecordLiveTest do
  use DogBookWeb.ConnCase

  import Phoenix.LiveViewTest
  import DogBook.DataFixtures

  @create_attrs %{country: "some country", registry_uid: "some registry_uid"}
  @update_attrs %{country: "some updated country", registry_uid: "some updated registry_uid"}
  @invalid_attrs %{country: nil, registry_uid: nil}

  defp create_record(_) do
    record = record_fixture()
    %{record: record}
  end

  describe "Index" do
    setup [:create_record]

    test "lists all records", %{conn: conn, record: record} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/records")

      assert html =~ "Listing Records"
      assert html =~ record.country
    end

    test "saves new record", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/records")

      assert index_live |> element("a", "New Record") |> render_click() =~
               "New Record"

      assert_patch(index_live, ~p"/admin/records/new")

      assert index_live
             |> form("#record-form", record: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#record-form", record: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/records")

      html = render(index_live)
      assert html =~ "Record created successfully"
      assert html =~ "some country"
    end

    test "updates record in listing", %{conn: conn, record: record} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/records")

      assert index_live |> element("#records-#{record.id} a", "Edit") |> render_click() =~
               "Edit Record"

      assert_patch(index_live, ~p"/admin/records/#{record}/edit")

      assert index_live
             |> form("#record-form", record: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#record-form", record: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/records")

      html = render(index_live)
      assert html =~ "Record updated successfully"
      assert html =~ "some updated country"
    end

    test "deletes record in listing", %{conn: conn, record: record} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/records")

      assert index_live |> element("#records-#{record.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#records-#{record.id}")
    end
  end

  describe "Show" do
    setup [:create_record]

    test "displays record", %{conn: conn, record: record} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/records/#{record}")

      assert html =~ "Show Record"
      assert html =~ record.country
    end

    test "updates record within modal", %{conn: conn, record: record} do
      {:ok, show_live, _html} = live(conn, ~p"/admin/records/#{record}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Record"

      assert_patch(show_live, ~p"/admin/records/#{record}/show/edit")

      assert show_live
             |> form("#record-form", record: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#record-form", record: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/admin/records/#{record}")

      html = render(show_live)
      assert html =~ "Record updated successfully"
      assert html =~ "some updated country"
    end
  end
end
