defmodule ExSeedify.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias ExSeedify.Repo

  alias ExSeedify.Schema.Salary
  alias ExSeedify.Schema.User
  alias ExSeedify.Salaries

  require Logger

  # =======================================================================
  # Types
  # =======================================================================
  @typep username :: User.name() | String.t()
  @type filter_params :: %{optional(:order_by) => String.t(), optional(:username) => username()}
  @type paginate_opts :: %{optional(:page) => integer(), optional(:page_size) => integer()}

  # =======================================================================
  # Public APIs
  # =======================================================================
  @doc """
  Returns the paginated list of users with active / recent active salary.

  ## Examples

      iex> list_users_with_salaries()
      Scrivener.Page{entries: [%{user: %User{id: 1001, name: "Joe", salary: %Salary{}}, ...]}
  """
  @spec list_users_with_salaries(filter_params(), paginate_opts()) :: Scrivener.Page.t()
  def list_users_with_salaries(filter_params \\ %{}, paginate_opts \\ %{}) do
    User
    |> join(:left, [u], s in subquery(Salaries.user_salary_subquery()), on: u.id == s.user_id)
    |> select([u, s], %{user: u, salary: s})
    |> filter_query(filter_params)
    |> Repo.paginate(paginate_opts)
  end

  @doc """
  Returns the list of users with active salary.

  ## Examples

      iex> fetch_users_with_active_salary()
      [%User{id: 1001, name: "Joe", active_salary: %Salary{}, ...}, ...]
  """
  @spec fetch_users_with_active_salary() :: Enum.t()
  def fetch_users_with_active_salary do
    User
    |> join(:left, [u], s in Salary, on: u.id == s.user_id)
    |> where([u, s], s.active == true)
    |> select([u, s], %{user: u, salary: s})
    |> Repo.stream()
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  @spec list_users() :: [User.t()]
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_user!(User.id()) :: User.t()
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_user(attrs :: map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_user(user :: User.t(), attrs :: map()) ::
          {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_user(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  @spec change_user(salary :: User.t(), attrs :: map()) :: Ecto.Changeset.t()
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  # =======================================================================
  # Private Functions
  # =======================================================================
  defp filter_query(query, params) do
    Enum.reduce(params, query, fn {filter, field}, query ->
      do_filter_query(query, filter, field)
    end)
  end

  defp do_filter_query(query, :username, nil = _username) do
    query
  end

  defp do_filter_query(query, :username, username) do
    partial_username = "%#{username}%"
    query |> where([u, s], ilike(u.name, ^partial_username))
  end

  defp do_filter_query(query, :order_by, "username") do
    query |> order_by([u, s], u.name)
  end

  defp do_filter_query(query, _filter, _field), do: query
end
