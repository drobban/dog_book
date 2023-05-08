defmodule DogBook.Repo.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records) do
      add :registry_uid, :string
      add :country, :string
      add :dog_id, references(:dogs, on_delete: :restrict)

      timestamps()
    end

    create index(:records, [:dog_id])
  end
end
