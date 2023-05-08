defmodule DogBook.Data.Record do
  use Ecto.Schema
  import Ecto.Changeset

  schema "records" do
    field :country, :string
    field :registry_uid, :string
    belongs_to :dog, DogBook.Data.Dog

    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:registry_uid, :country, :dog_id])
    |> validate_required([:registry_uid])
  end
end
