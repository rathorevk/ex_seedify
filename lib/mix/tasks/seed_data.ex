defmodule Mix.Tasks.SeedData do
  use Mix.Task

  alias ExSeedify.Salaries
  alias ExSeedify.Users

  alias ExSeedify.Schema.User

  @users_count 20_000
  @names ExSeedify.list_names()

  @supported_currencies Application.compile_env(:ex_seedify, :currencies)
  @max_salary 10_000

  @max_concurrency System.schedulers_online()

  @impl true
  def run(_args) do
    start_time = DateTime.utc_now()
    IO.puts("Started seeding users and salaries tables...")

    Mix.Task.run("app.start")

    1..@users_count
    |> Task.async_stream(
      fn _x ->
        seed_user()
        |> seed_salaries()
      end,
      max_concurrency: @max_concurrency,
      ordered: false
    )
    |> Stream.run()

    end_time = DateTime.utc_now()

    duration = DateTime.diff(end_time, start_time, :millisecond)
    IO.puts("Seeding of users and salaries tables completed in #{duration} millisecond.")
  end

  defp seed_user do
    name = Enum.random(@names)
    {:ok, user} = Users.create_user(%{name: name})

    user
  end

  defp seed_salaries(%User{id: user_id}) do
    salary_statuses = Enum.random([[false, true], [false, false]])

    salary_statuses
    |> Enum.map(&salary_params(user_id, &1))
    |> Salaries.insert_salaries(placeholders: %{now: DateTime.utc_now()})
  end

  defp salary_params(user_id, active) do
    amount = Enum.random(1000..@max_salary)
    currency = Enum.random(@supported_currencies)

    %{
      active: active,
      amount: amount,
      currency: currency,
      user_id: user_id,
      inserted_at: {:placeholder, :now},
      updated_at: {:placeholder, :now}
    }
  end
end
