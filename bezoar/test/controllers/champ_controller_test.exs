defmodule Bezoar.ChampControllerTest do
  use Bezoar.ConnCase

  alias Bezoar.Champ
  #@valid_attrs %{hp: 42, hp_max: 42, name: "Minotaur", player_id: -1, hp_base: 42}
  @invalid_attrs %{hp: 42, name: "Spider Goat"}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, champ_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing champs"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, champ_path(conn, :new)
    assert html_response(conn, 200) =~ "New champ"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    player = insert(:player)
    champ  = params_for(:champ, %{player_id: player.id})

    conn = post conn, champ_path(conn, :create), champ: champ
    assert redirected_to(conn) == champ_path(conn, :index)
    assert Repo.get_by(Champ, %{name: champ.name})
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, champ_path(conn, :create), champ: @invalid_attrs
    assert html_response(conn, 200) =~ "New champ"
  end

  test "shows chosen resource", %{conn: conn} do
    champ = insert(:champ)
    conn = get conn, champ_path(conn, :show, champ)
    assert html_response(conn, 200) =~ "Show champ"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, champ_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    champ = insert(:champ)
    conn = get conn, champ_path(conn, :edit, champ)
    assert html_response(conn, 200) =~ "Edit champ"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    champ = insert(:champ)
    conn = put conn, champ_path(conn, :update, champ), champ: %{name: "Iguana"}
    assert redirected_to(conn) == champ_path(conn, :show, champ)
    assert Repo.get_by(Champ, %{name: "Iguana"})
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    champ = insert(:champ)
    conn = put conn, champ_path(conn, :update, champ), champ: %{player_id: -1}
    assert html_response(conn, 200) =~ "Edit champ"
  end

  test "deletes chosen resource", %{conn: conn} do
    champ = insert(:champ)
    conn = delete conn, champ_path(conn, :delete, champ)
    assert redirected_to(conn) == champ_path(conn, :index)
    refute Repo.get(Champ, champ.id)
  end
end
