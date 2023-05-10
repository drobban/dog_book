defmodule DogBook.Meta.ChampionDogs do
  use Ecto.Schema
  import Ecto.Changeset

  schema "champion_dogs" do
    field :champion_id, :id
    field :dog_id, :id

    timestamps()
  end

  @doc false
  def changeset(champion_dogs, attrs) do
    champion_dogs
    |> cast(attrs, [])
    |> validate_required([])
  end
end
