defmodule ExSeedifyWeb.PageController do
  use ExSeedifyWeb, :controller

  def ping(conn, _params) do
    render(conn, :ping)
  end
end
