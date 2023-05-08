defmodule DogBook.Meta.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "persons" do
    field :city, :string
    field :name, :string
    field :phone, :string
    field :street, :string
    field :zip_code, :integer

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :street, :zip_code, :city, :phone])
    |> validate_required([:name, :street])
  end
end
