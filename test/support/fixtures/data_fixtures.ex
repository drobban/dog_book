defmodule DogBook.DataFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DogBook.Data` context.
  """

  @doc """
  Generate a dog.
  """
  def dog_fixture(attrs \\ %{}) do
    {:ok, dog} =
      attrs
      |> Enum.into(%{
        birth_date: ~D[2023-05-07],
        breed_specific: :bobtail,
        coat: :short,
        gender: :male,
        name: "some name",
        observe: true,
        partial: true,
        size: :normal,
        testicle_status: :ok
      })
      |> DogBook.Data.create_dog()

    dog |> DogBook.Repo.preload([:records, :breed, :parents])
  end

  @doc """
  Generate a record.
  """
  def record_fixture(attrs \\ %{}) do
    {:ok, record} =
      attrs
      |> Enum.into(%{
        country: "some country",
        registry_uid: "some registry_uid"
      })
      |> DogBook.Data.create_record()

    record
  end
end
