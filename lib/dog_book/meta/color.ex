defmodule DogBook.Meta.Color do
  use Ecto.Schema
  import Ecto.Changeset

  schema "colors" do
    field :color, :string
    field :number, :integer

    timestamps()
  end

  @doc false
  def changeset(color, attrs) do
    color
    |> cast(attrs, [:number, :color])
    |> validate_required([:number, :color])
  end
end
