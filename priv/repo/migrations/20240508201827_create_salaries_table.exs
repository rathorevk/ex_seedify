defmodule ExSeedify.Repo.Migrations.CreateSalariesTable do
  use Ecto.Migration

  def change do
    create table(:salaries) do
      add :currency, :string
      add :active, :boolean, default: false, null: false
      add :amount, :integer, default: 0, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime_usec)
    end

    create index(:salaries, [:user_id])

    execute("""
      CREATE UNIQUE INDEX idx_unique_active_salary_per_user
      ON salaries (user_id)
      WHERE active=true;
    """)
  end
end
