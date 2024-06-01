defmodule ExSeedifyWeb.UserJSON do
  @doc """
  Renders a list of users.
  """

  def list_users(%{data: data}) do
    Map.from_struct(%{data | entries: Enum.map(data.entries, &data/1)})
  end

  defp data(%{user: %{id: id, name: name}, salary: salary}) do
    %{
      user_id: id,
      user_name: name,
      salary: %{amount: salary.amount, currency: salary.currency}
    }
  end
end
