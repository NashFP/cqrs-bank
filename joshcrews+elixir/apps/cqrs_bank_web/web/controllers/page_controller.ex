defmodule CqrsBankWeb.PageController do
  use CqrsBankWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
