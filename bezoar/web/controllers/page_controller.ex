defmodule Bezoar.PageController do
  use Bezoar.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
