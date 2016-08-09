defmodule Bezoar.ChampController do
  use Bezoar.Web, :controller

  alias Bezoar.Champ

  plug :scrub_params, "champ" when action in [:create, :update]

  def index(conn, _params) do
    champs = Repo.all(Champ)
    render(conn, "index.html", champs: champs)
  end

  def new(conn, _params) do
    changeset = Champ.changeset(%Champ{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"champ" => champ_params}) do
    changeset = Champ.changeset(%Champ{}, champ_params)

    case Repo.insert(changeset) do
      {:ok, _champ} ->
        conn
        |> put_flash(:info, "Champ created successfully.")
        |> redirect(to: champ_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    champ = Repo.get!(Champ, id) |> Repo.preload(:skills)
    render(conn, "show.html", champ: champ)
  end

  def edit(conn, %{"id" => id}) do
    champ = Repo.get!(Champ, id) |> Repo.preload(:champ_skills)
    changeset = Champ.changeset(champ)
    render(conn, "edit.html", champ: champ, changeset: changeset)
  end

  def update(conn, %{"id" => id, "champ" => champ_params}) do
    champ = Repo.get!(Champ, id) |> Repo.preload(:champ_skills)
    changeset = Champ.changeset(champ, champ_params)

    case Repo.update(changeset) do
      {:ok, champ} ->
        conn
        |> put_flash(:info, "Champ updated successfully.")
        |> redirect(to: champ_path(conn, :show, champ))
      {:error, changeset} ->
        render(conn, "edit.html", champ: champ, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    champ = Repo.get!(Champ, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(champ)

    conn
    |> put_flash(:info, "Champ deleted successfully.")
    |> redirect(to: champ_path(conn, :index))
  end
end
