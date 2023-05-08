defmodule DogBook.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons) do
      add :name, :string
      add :street, :string
      add :zip_code, :integer
      add :city, :string
      add :phone, :string

      timestamps()
    end
  end
end
