defmodule ExSeedifyWeb.UserControllerTest do
  use ExSeedifyWeb.ConnCase

  import ExSeedify.SalariesFixtures
  import ExSeedify.UsersFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "GET /users" do
    setup do
      %{user: _user1, salary: _salary1} = user1 = create_user(%{name: "Green"})
      %{user: _user2, salary: _salary2} = user2 = create_user(%{name: "Alex"})

      {:ok, users: [user1, user2]}
    end

    test "returns paginated list of users with salaries", %{conn: conn, users: users} do
      [%{user: user1, salary: salary1}, %{user: user2, salary: salary2}] = users

      assert %{"page_number" => 1, "page_size" => 1, "entries" => [user_resp]} =
               conn
               |> get(~p"/users", %{page_size: 1})
               |> json_response(200)

      assert user_resp["user_id"] == user1.id
      assert user_resp["user_name"] == user1.name
      assert user_resp["salary"]["amount"] == salary1.amount
      assert user_resp["salary"]["currency"] == to_string(salary1.currency)

      assert %{"page_number" => 2, "page_size" => 1, "entries" => [user_resp]} =
               conn
               |> get(~p"/users", %{page: 2, page_size: 1})
               |> json_response(200)

      assert user_resp["user_id"] == user2.id
      assert user_resp["user_name"] == user2.name
      assert user_resp["salary"]["amount"] == salary2.amount
      assert user_resp["salary"]["currency"] == to_string(salary2.currency)
    end

    test "filter paginated list by username", %{conn: conn, users: [user1 | _]} do
      assert %{"page_number" => 1, "entries" => [user_resp]} =
               conn
               |> get(~p"/users", %{username: user1.user.name})
               |> json_response(200)

      assert user_resp["user_id"] == user1.user.id
      assert user_resp["user_name"] == user1.user.name
    end

    test "order paginated list by username", %{conn: conn, users: users} do
      [%{user: user1}, %{user: user2}] = users
      # user1.name = "Green"
      # user2.name = "Alex"

      assert %{"page_number" => 1, "entries" => [user_resp1, user_resp2]} =
               conn
               |> get(~p"/users", %{order_by: :username})
               |> json_response(200)

      assert user_resp1["user_id"] == user2.id
      assert user_resp1["user_name"] == user2.name

      assert user_resp2["user_id"] == user1.id
      assert user_resp2["user_name"] == user1.name
    end
  end

  describe "POST /invite-users" do
    setup [:create_user]

    test "successfully send invitation to active users", %{conn: conn} do
      conn = post(conn, ~p"/invite-users")
      assert json_response(conn, 200)
    end
  end

  defp create_user(attrs \\ %{}) do
    user = user_fixture(attrs)
    salary = salary_fixture(%{user_id: user.id})

    %{user: user, salary: salary}
  end
end
