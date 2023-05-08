defmodule DogBook.Data.Dog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dogs" do
    field :birth_date, :date
    field :breed_specific, Ecto.Enum, values: [:bobtail, :docked, :measured]
    field :coat, Ecto.Enum, values: [:short, :long, :broken]
    field :gender, Ecto.Enum, values: [:male, :female]
    field :name, :string
    field :observe, :boolean, default: false
    field :partial, :boolean, default: false
    field :size, Ecto.Enum, values: [:normal, :dwarf, :rabbit]
    field :testicle_status, Ecto.Enum, values: [:ok, :cryptochid, :unknown]
    belongs_to :breed, DogBook.Meta.Breed
    belongs_to :breeder, DogBook.Meta.Breeder
    belongs_to :color, DogBook.Meta.Color

    timestamps()
  end

  @doc false
  def changeset(dog, attrs) do
    dog
    |> cast(attrs, [
      :name,
      :gender,
      :birth_date,
      :breed_specific,
      :coat,
      :size,
      :observe,
      :testicle_status,
      :partial
    ])
    |> validate_required([
      :name,
      :gender,
      :birth_date,
      :breed_specific,
      :coat,
      :size,
      :observe,
      :testicle_status,
      :partial
    ])
  end
end
