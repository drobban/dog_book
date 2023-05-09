defmodule DogBook.Data.DogParents do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dog_parents" do
    field :dog_id, :id
    field :parent_id, :id

    timestamps()
  end

  @doc false
  def changeset(dog_parents, attrs) do
    dog_parents
    |> cast(attrs, [])
    |> validate_required([])
  end
end
