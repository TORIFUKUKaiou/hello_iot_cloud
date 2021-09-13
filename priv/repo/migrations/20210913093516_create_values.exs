defmodule HelloIotCloud.Repo.Migrations.CreateValues do
  use Ecto.Migration

  def change do
    create table(:values) do
      add :humidity, :float
      add :temperature, :float
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:values, [:user_id])
  end
end
