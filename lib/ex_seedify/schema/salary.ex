defmodule ExSeedify.Schema.Salary do
  use TypedEctoSchema

  import Ecto.Changeset

  typed_schema "salaries" do
    field :active, :boolean, default: false
    field :amount, :integer
    field :currency, Ecto.Enum, values: [:USD, :EUR, :JPY, :GBP]

    belongs_to :users, ExSeedify.Schema.User, foreign_key: :user_id

    timestamps(type: :utc_datetime_usec)
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(salary, attrs) do
    salary
    |> cast(attrs, [:currency, :active, :amount, :user_id])
    |> validate_required([:currency, :active, :amount, :user_id])
    |> unique_constraint([:active, :user_id],
      name: :idx_unique_active_salary_per_user,
      message: "already has an active salary"
    )
  end
end
