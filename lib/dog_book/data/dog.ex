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

    many_to_many :parents, DogBook.Data.Dog,
      join_through: DogBook.Data.DogParents,
      join_keys: [parent_id: :id, dog_id: :id],
      on_replace: :delete

    many_to_many :dogs, DogBook.Data.Dog,
      join_through: DogBook.Data.DogParents,
      join_keys: [dog_id: :id, parent_id: :id],
      on_replace: :delete

    has_many :records, DogBook.Data.Record

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
      :partial,
      :breed_id,
      :color_id,
      :breeder_id
    ])
    # |> put_assoc(:parents, parents)
    |> validate_required([
      :name,
      :gender,
      :observe,
      :testicle_status,
      :partial
    ])
  end

  def partial_parent(dog, attrs) do
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
      :partial,
      :breed_id,
      :color_id,
      :breeder_id
    ])
    # |> put_assoc(:parents, parents)
    |> validate_required([
      :gender,
      :breed_id
    ])
  end

  def imperfect_changeset(dog, attrs) do
    records = Map.get(attrs, :records, [])

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
      :partial,
      :breed_id,
      :color_id,
      :breeder_id
    ])
    |> put_assoc(:records, records)
    |> validate_required([
      :name,
      :gender,
      :observe,
      :testicle_status
    ])
  end

  def parents_changeset(dog, attrs) do
    parents = Map.get(attrs, :parents, [nil])

    dog
    |> DogBook.Repo.preload(:parents)
    |> cast(attrs, [
      :name,
      :gender,
      :birth_date,
      :breed_specific,
      :coat,
      :size,
      :observe,
      :testicle_status,
      :partial,
      :breed_id,
      :color_id,
      :breeder_id
    ])
    |> put_assoc(:parents, parents)
    |> validate_required([
      :name,
      :gender,
      :observe,
      :testicle_status
    ])
  end
end
