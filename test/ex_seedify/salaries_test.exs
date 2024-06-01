defmodule ExSeedify.SalariesTest do
  use ExSeedify.DataCase, async: true

  alias ExSeedify.Salaries
  alias ExSeedify.Schema.Salary

  import ExSeedify.SalariesFixtures
  import ExSeedify.UsersFixtures

  @invalid_attrs %{active: nil, amount: nil, currency: nil}

  test "list_salaries/0 returns all salaries" do
    salary = create_salary()
    assert Salaries.list_salaries() == [salary]
  end

  test "get_salary!/1 returns the salary with given id" do
    salary = create_salary()
    assert Salaries.get_salary!(salary.id) == salary
  end

  describe "create_salary/1" do
    test "with valid data creates a salary" do
      user = user_fixture()
      valid_attrs = %{active: true, amount: 42, currency: :USD, user_id: user.id}

      assert {:ok, %Salary{} = salary} = Salaries.create_salary(valid_attrs)
      assert salary.active == true
      assert salary.amount == 42
      assert salary.currency == :USD
      assert salary.user_id == user.id
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Salaries.create_salary(@invalid_attrs)
    end
  end

  describe "update_salary/2" do
    test "with valid data updates the salary" do
      salary = create_salary()
      update_attrs = %{active: false, amount: 43, currency: :GBP}

      assert {:ok, %Salary{} = salary} = Salaries.update_salary(salary, update_attrs)
      assert salary.active == false
      assert salary.amount == 43
      assert salary.currency == :GBP
    end

    test "with invalid data returns error changeset" do
      salary = create_salary()
      assert {:error, %Ecto.Changeset{}} = Salaries.update_salary(salary, @invalid_attrs)
      assert salary == Salaries.get_salary!(salary.id)
    end
  end

  test "delete_salary/1 deletes the salary" do
    salary = create_salary()
    assert {:ok, %Salary{}} = Salaries.delete_salary(salary)
    assert_raise Ecto.NoResultsError, fn -> Salaries.get_salary!(salary.id) end
  end

  test "change_salary/1 returns a salary changeset" do
    salary = create_salary()
    assert %Ecto.Changeset{} = Salaries.change_salary(salary)
  end

  defp create_salary do
    user = user_fixture()
    salary_fixture(%{user_id: user.id})
  end
end
