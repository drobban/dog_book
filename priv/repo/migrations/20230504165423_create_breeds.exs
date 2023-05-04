defmodule DogBook.Repo.Migrations.CreateBreeds do
  use Ecto.Migration

  def change do
    create table(:breeds) do
      add :number, :integer
      add :name, :string

      timestamps()
    end
  end
end
