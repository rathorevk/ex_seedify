defmodule ExSeedify.UsersTest do
  use ExSeedify.DataCase, async: true

  alias ExSeedify.Schema.User
  alias ExSeedify.Users

  import ExSeedify.SalariesFixtures
  import ExSeedify.UsersFixtures

  describe "list_users_with_salaries/0" do
    test "returns empty paginated list when user doesn't exist" do
      assert %Scrivener.Page{
               page_number: 1,
               page_size: 30,
               total_entries: 0,
               total_pages: 1,
               entries: []
             } ==
               Users.list_users_with_salaries()
    end

    test "returns paginated users with salary" do
      user = user_fixture()
      salary1 = salary_fixture(%{user_id: user.id, active: true})
      _salary2 = salary_fixture(%{user_id: user.id, active: false})

      assert %Scrivener.Page{entries: [response]} = Users.list_users_with_salaries()

      assert response.user.id == user.id
      assert response.user.name == user.name
      assert response.salary.id == salary1.id
      assert response.salary.active == salary1.active
    end
  end

  describe "users" do
    @invalid_attrs %{name: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
