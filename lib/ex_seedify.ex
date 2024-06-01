defmodule ExSeedify do
  @moduledoc """
  ExSeedify keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @names ExSeedify.Services.ListNamesFromFile.call()

  alias ExSeedify.Schema.User
  alias ExSeedify.Users

  require Logger

  # =======================================================================
  # Macros
  # =======================================================================
  @retries 3

  # =======================================================================
  # Public APIs
  # =======================================================================
  @spec list_users_with_salaries(Users.filter_params(), Users.paginate_opts()) ::
          Scrivener.Page.t()
  defdelegate list_users_with_salaries(filter_params, paginate_opts), to: Users

  @doc """
  Send async email invitation to all users with active salary.
  if failed retry attempt as configured.
  """
  @spec invite_users() :: :ok
  def invite_users do
    ExSeedify.Repo.transaction(fn ->
      Users.fetch_users_with_active_salary()
      |> Stream.each(&send_invitation/1)
      |> Stream.run()
    end)

    :ok
  end

  # =======================================================================
  # Private Functions
  # =======================================================================
  defp send_invitation(%{user: %User{name: name} = user}, retries \\ @retries) do
    %{name: name}
    |> send_email()
    |> handle_response(user, retries)
  end

  defp handle_response({:ok, _user}, %User{id: id}, _retry) do
    Logger.info("Successfully sent invitation to user: #{id}!")
  end

  defp handle_response({:error, error}, %User{id: id}, 0 = _retry) do
    Logger.error("Exhausted retry invite attempts to user: #{id}, error: #{inspect(error)}!")
    :ok
  end

  defp handle_response({:error, error}, %User{id: id} = user, retry) do
    Logger.info(
      "User #{id} invitation failed with error: #{inspect(error)} retry attempt left: #{retry}!"
    )

    send_invitation(user, retry - 1)
  end

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
