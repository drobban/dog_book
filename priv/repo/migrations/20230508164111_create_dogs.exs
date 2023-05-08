defmodule DogBook.Repo.Migrations.CreateDogs do
  use Ecto.Migration

  def change do
    create table(:dogs) do
      add :name, :string
      add :gender, :string
      add :birth_date, :date
      add :breed_specific, :string
      add :coat, :string
      add :size, :string
      add :observe, :boolean, default: false, null: false
      add :testicle_status, :string
      add :partial, :boolean, default: false, null: false
      add :breed_id, references(:breeds, on_delete: :nothing)
      add :breeder_id, references(:breeders, on_delete: :nothing)
      add :color_id, references(:colors, on_delete: :nothing)

      timestamps()
    end

    create index(:dogs, [:breed_id])
    create index(:dogs, [:breeder_id])
    create index(:dogs, [:color_id])
  end
end
