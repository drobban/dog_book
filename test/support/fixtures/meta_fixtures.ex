defmodule DogBook.MetaFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DogBook.Meta` context.
  """

  @doc """
  Generate a breed.
  """
  def breed_fixture(attrs \\ %{}) do
    {:ok, breed} =
      attrs
      |> Enum.into(%{
        name: "some name",
        number: 42
      })
      |> DogBook.Meta.create_breed()

    breed
  end
end
