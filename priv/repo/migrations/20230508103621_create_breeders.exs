defmodule DogBook.Repo.Migrations.CreateBreeders do
  use Ecto.Migration

  def change do
    create table(:breeders) do
      add :number, :integer
      add :name, :string

      timestamps()
    end
  end
end
