defmodule DogBook.Meta.BreederPersons do
  use Ecto.Schema
  import Ecto.Changeset

  schema "breeder_persons" do
    belongs_to :breeder, DogBook.Meta.Breeder
    belongs_to :person, DogBook.Meta.Person

    timestamps()
  end

  @doc false
  def changeset(breeder_persons, attrs) do
    breeder_persons
    |> cast(attrs, [])
    |> validate_required([])
  end
end
