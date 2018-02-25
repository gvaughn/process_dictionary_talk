defmodule LonestarPdWeb.PageController do
  use LonestarPdWeb, :controller

  def index(conn, _params) do
    :rand.uniform()
    Gettext.put_locale("en_TX")
    render conn, "index.html"
  end
end
