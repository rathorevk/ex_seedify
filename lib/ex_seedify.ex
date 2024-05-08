defmodule ExSeedify do
  @moduledoc """
  ExSeedify keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @names ExSeedify.Services.ListNamesFromFile.call()

  @doc """
  Sends an email to a user.

  To make the challenge simpler instead of this function receiving a user email it receives a name.
  """
  @spec send_email(%{name: String.t()}) :: {:ok, String.t()} | {:error, atom()}
  def send_email(%{name: name}) when is_binary(name) do
    sleep_time = calculate_sleep_time_in_ms()

    # simulate send email
    :timer.sleep(sleep_time)

    case Enum.random(1..500_000) do
      1 -> {:error, :econnrefused}
      _ -> {:ok, name}
    end
  end

  def send_email(_), do: {:error, :invalid_attrs}

  @doc """
  Returns a list containing examples of user names
  """
  @spec list_names() :: list(String.t())
  def list_names, do: @names

  defp calculate_sleep_time_in_ms, do: Enum.random(0..2)
end
