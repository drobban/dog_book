defmodule DogBook.Data.DogParents do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dog_parents" do
    belongs_to :dog, DogBook.Data.Dog
    belongs_to :parent, DogBook.Data.Dog

    timestamps()
  end

  @doc false
  def changeset(dog_parents, attrs) do
    dog_parents
    |> cast(attrs, [])
    |> validate_required([])
  end
end
