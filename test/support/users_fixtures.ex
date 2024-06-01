defmodule ExSeedify.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExSeedify.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> ExSeedify.Users.create_user()

    user
  end
end
