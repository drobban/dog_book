defmodule DogBook.Meta.Breeder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "breeders" do
    field :name, :string
    field :number, :integer

    many_to_many :persons, DogBook.Meta.Person,
      join_through: DogBook.Meta.BreederPersons,
      on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(breeder, attrs) do
    persons = Map.get(attrs, :persons, [])

    breeder
    |> cast(attrs, [:number, :name])
    |> put_assoc(:persons, persons)
    |> validate_required([:number, :name])
  end
end
