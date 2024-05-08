defmodule ExSeedifyWeb.PageControllerTest do
  use ExSeedifyWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert json_response(conn, 200)
  end
end
