defmodule DogBook.Repo.Migrations.CreateBreederPersons do
  use Ecto.Migration

  def change do
    create table(:breeder_persons) do
      add :breeder_id, references(:breeders, on_delete: :restrict)
      add :person_id, references(:persons, on_delete: :restrict)

      timestamps()
    end

    create index(:breeder_persons, [:breeder_id])
    create index(:breeder_persons, [:person_id])

    create(
      unique_index(:breeder_persons, [:breeder_id, :person_id],
        name: :breeder_id_person_id_unique_index
      )
    )
  end
end
