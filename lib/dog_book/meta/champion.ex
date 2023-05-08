defmodule DogBook.Meta.Champion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "champions" do
    field :champ_name, :string
    field :number, :integer

    timestamps()
  end

  @doc false
  def changeset(champion, attrs) do
    champion
    |> cast(attrs, [:number, :champ_name])
    |> validate_required([:number, :champ_name])
  end
end
