defmodule DogBook.Repo.Migrations.CreateChampions do
  use Ecto.Migration

  def change do
    create table(:champions) do
      add :number, :integer
      add :champ_name, :string

      timestamps()
    end
  end
end
