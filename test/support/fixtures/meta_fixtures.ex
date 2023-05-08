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

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        city: "some city",
        name: "some name",
        phone: "some phone",
        street: "some street",
        zip_code: 42
      })
      |> DogBook.Meta.create_person()

    person
  end

  @doc """
  Generate a breeder.
  """
  def breeder_fixture(attrs \\ %{}) do
    {:ok, breeder} =
      attrs
      |> Enum.into(%{
        name: "some name",
        number: 42
      })
      |> DogBook.Meta.create_breeder()

    breeder
  end

  @doc """
  Generate a champion.
  """
  def champion_fixture(attrs \\ %{}) do
    {:ok, champion} =
      attrs
      |> Enum.into(%{
        champ_name: "some champ_name",
        number: 42
      })
      |> DogBook.Meta.create_champion()

    champion
  end
end
