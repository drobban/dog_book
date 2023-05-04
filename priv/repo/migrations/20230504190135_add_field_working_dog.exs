defmodule DogBook.Repo.Migrations.AddFieldWorkingDog do
  use Ecto.Migration

  def change do
    alter table(:breeds) do
      add :sbk_working_dog, :boolean
    end
  end
end
