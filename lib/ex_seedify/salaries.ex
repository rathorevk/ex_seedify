defmodule ExSeedify.Salaries do
  @moduledoc """
  The Salaries context.
  """

  import Ecto.Query, warn: false
  alias ExSeedify.Repo

  alias ExSeedify.Schema.Salary

  # =======================================================================
  # Public APIs
  # =======================================================================
  @doc """
  Returns the query to fetch active / recent active user salary.

  ## Examples

      iex> user_salary_subquery()
      #Ecto.Query<from s0 in ExSeedify.Schema.Salary,
      order_by: [desc: s0.active, desc: s0.updated_at], distinct: [asc: s0.user_id]>
  """
  @spec user_salary_subquery() :: Ecto.Query.t()
  def user_salary_subquery do
    from(s in Salary, order_by: [desc: s.active, desc: s.updated_at], distinct: s.user_id)
  end

  @doc """
  Returns the list of salaries.

  ## Examples

      iex> list_salaries()
      [%Salary{}, ...]

  """
  @spec list_salaries() :: [Salary.t()]
  def list_salaries do
    Repo.all(Salary)
  end

  @doc """
  Gets a single salary.

  Raises `Ecto.NoResultsError` if the Salary does not exist.

  ## Examples

      iex> get_salary!(123)
      %Salary{}

      iex> get_salary!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_salary!(Salary.id()) :: Salary.t()
  def get_salary!(id), do: Repo.get!(Salary, id)

  @doc """
  Creates a salary.

  ## Examples

      iex> create_salary(%{field: value})
      {:ok, %Salary{}}

      iex> create_salary(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_salary(attrs :: map()) :: {:ok, Salary.t()} | {:error, Ecto.Changeset.t()}
  def create_salary(attrs) do
    %Salary{}
    |> Salary.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Inserts multiple users into the database after validating the data.

  ## Examples

      iex> insert_salaries([
      ...>   %{name: "Alice", email: "alice@example.com"},
      ...>   %{name: "Bob", email: "bob@example.com"}
      ...> ])
      {:ok, 2}

      iex> insert_salaries([
      ...>   %{name: "Alice"},
      ...>   %{name: "Bob", email: "bob@example.com"}
      ...> ])
      {:error, :validation_failed}

  """
  # @spec insert_salaries(entries :: [map()]) :: {:ok, [Salary.t()] | :validation_failed}
  def insert_salaries(entries, opts) do
    Repo.insert_all(Salary, entries, opts)
    # changesets = Enum.map(attrs, &Salary.changeset(%Salary{}, &1))

    # if Enum.all?(changesets, & &1.valid?) do
    #   salaries_data = Enum.map(changesets, &Ecto.Changeset.apply_changes/1)
    #   {:ok, Repo.insert_all(Salary, salaries_data)}
    # else
    #   {:error, :validation_failed}
    # end
  end

  @doc """
  Updates a salary.

  ## Examples

      iex> update_salary(salary, %{field: new_value})
      {:ok, %Salary{}}

      iex> update_salary(salary, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_salary(salary :: Salary.t(), attrs :: map()) ::
          {:ok, Salary.t()} | {:error, Ecto.Changeset.t()}
  def update_salary(%Salary{} = salary, attrs) do
    salary
    |> Salary.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a salary.

  ## Examples

      iex> delete_salary(salary)
      {:ok, %Salary{}}

      iex> delete_salary(salary)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_salary(Salary.t()) :: {:ok, Salary.t()} | {:error, Ecto.Changeset.t()}
  def delete_salary(%Salary{} = salary) do
    Repo.delete(salary)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking salary changes.

  ## Examples

      iex> change_salary(salary)
      %Ecto.Changeset{data: %Salary{}}

  """
  @spec change_salary(salary :: Salary.t(), attrs :: map()) :: Ecto.Changeset.t()
  def change_salary(%Salary{} = salary, attrs \\ %{}) do
    Salary.changeset(salary, attrs)
  end
end
