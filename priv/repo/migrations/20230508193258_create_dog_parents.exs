defmodule DogBook.Repo.Migrations.CreateDogParents do
  use Ecto.Migration

  def change do
    create table(:dog_parents) do
      add :dog_id, references(:dogs, on_delete: :nothing)
      add :parent_id, references(:dogs, on_delete: :nothing)

      timestamps()
    end

    create index(:dog_parents, [:dog_id])
    create index(:dog_parents, [:parent_id])

    create(
      unique_index(:dog_parents, [:dog_id, :parent_id], name: :dog_id_parent_id_unique_index)
    )
  end
end
