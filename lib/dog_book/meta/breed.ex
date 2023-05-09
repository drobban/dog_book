defmodule DogBook.Meta.Breed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "breeds" do
    field :name, :string
    field :number, :integer
    field :sbk_working_dog, :boolean, default: false

    # has_many :dogs, DogBook.Data.Dog

    timestamps()
  end

  @doc false
  def changeset(breed, attrs) do
    breed
    |> cast(attrs, [:number, :name, :sbk_working_dog])
    |> validate_required([:number, :name, :sbk_working_dog])
  end
end
