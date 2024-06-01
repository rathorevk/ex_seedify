defmodule ExSeedify.Schema.User do
  use TypedEctoSchema
  import Ecto.Changeset

  typed_schema "users" do
    field :name, :string

    has_many :salaries, ExSeedify.Schema.Salary
    timestamps(type: :utc_datetime_usec)
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
