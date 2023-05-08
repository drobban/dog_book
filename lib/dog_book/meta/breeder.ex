defmodule DogBook.Meta.Breeder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "breeders" do
    field :name, :string
    field :number, :integer

    timestamps()
  end

  @doc false
  def changeset(breeder, attrs) do
    breeder
    |> cast(attrs, [:number, :name])
    |> validate_required([:number, :name])
  end
end
