defmodule DogBook.Repo.Migrations.CreateChampionDogs do
  use Ecto.Migration

  def change do
    create table(:champion_dogs) do
      add :champion_id, references(:champions, on_delete: :nothing)
      add :dog_id, references(:dogs, on_delete: :nothing)

      timestamps()
    end

    create index(:champion_dogs, [:champion_id])
    create index(:champion_dogs, [:dog_id])

    create(
      unique_index(:champion_dogs, [:champion_id, :dog_id], name: :champion_id_dog_id_unique_index)
    )
  end
end
