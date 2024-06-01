defmodule ExSeedify.SalariesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExSeedify.Salaries` context.
  """

  @currencies Application.compile_env(:ex_seedify, :currencies)

  @doc """
  Generate a salary.
  """
  def salary_fixture(attrs \\ %{}) do
    {:ok, salary} =
      attrs
      |> Enum.into(%{
        active: Enum.random([true, false]),
        amount: Enum.random(1000..9000),
        currency: Enum.random(@currencies)
      })
      |> ExSeedify.Salaries.create_salary()

    salary
  end
end
