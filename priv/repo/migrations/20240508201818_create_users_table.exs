defmodule ExSeedify.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string

      timestamps(type: :utc_datetime_usec)
    end
  end
end
