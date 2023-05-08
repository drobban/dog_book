defmodule DogBook.Meta do
  @moduledoc """
  The Meta context.
  """

  import Ecto.Query, warn: false
  alias DogBook.Repo

  alias DogBook.Meta.Breed

  @doc """
  Returns the list of breeds.

  ## Examples

      iex> list_breeds()
      [%Breed{}, ...]

  """
  def list_breeds do
    Repo.all(Breed)
  end

  @doc """
  Gets a single breed.

  Raises `Ecto.NoResultsError` if the Breed does not exist.

  ## Examples

      iex> get_breed!(123)
      %Breed{}

      iex> get_breed!(456)
      ** (Ecto.NoResultsError)

  """
  def get_breed!(id), do: Repo.get!(Breed, id)

  @doc """
  Creates a breed.

  ## Examples

      iex> create_breed(%{field: value})
      {:ok, %Breed{}}

      iex> create_breed(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_breed(attrs \\ %{}) do
    %Breed{}
    |> Breed.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a breed.

  ## Examples

      iex> update_breed(breed, %{field: new_value})
      {:ok, %Breed{}}

      iex> update_breed(breed, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_breed(%Breed{} = breed, attrs) do
    breed
    |> Breed.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a breed.

  ## Examples

      iex> delete_breed(breed)
      {:ok, %Breed{}}

      iex> delete_breed(breed)
      {:error, %Ecto.Changeset{}}

  """
  def delete_breed(%Breed{} = breed) do
    Repo.delete(breed)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking breed changes.

  ## Examples

      iex> change_breed(breed)
      %Ecto.Changeset{data: %Breed{}}

  """
  def change_breed(%Breed{} = breed, attrs \\ %{}) do
    Breed.changeset(breed, attrs)
  end

  alias DogBook.Meta.Person

  @doc """
  Returns the list of persons.

  ## Examples

      iex> list_persons()
      [%Person{}, ...]

  """
  def list_persons do
    Repo.all(Person)
  end

  @doc """
  Gets a single person.

  Raises `Ecto.NoResultsError` if the Person does not exist.

  ## Examples

      iex> get_person!(123)
      %Person{}

      iex> get_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_person!(id), do: Repo.get!(Person, id)

  @doc """
  Creates a person.

  ## Examples

      iex> create_person(%{field: value})
      {:ok, %Person{}}

      iex> create_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a person.

  ## Examples

      iex> update_person(person, %{field: new_value})
      {:ok, %Person{}}

      iex> update_person(person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a person.

  ## Examples

      iex> delete_person(person)
      {:ok, %Person{}}

      iex> delete_person(person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person(%Person{} = person) do
    Repo.delete(person)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person changes.

  ## Examples

      iex> change_person(person)
      %Ecto.Changeset{data: %Person{}}

  """
  def change_person(%Person{} = person, attrs \\ %{}) do
    Person.changeset(person, attrs)
  end

  alias DogBook.Meta.Breeder

  @doc """
  Returns the list of breeders.

  ## Examples

      iex> list_breeders()
      [%Breeder{}, ...]

  """
  def list_breeders do
    Repo.all(Breeder)
  end

  @doc """
  Gets a single breeder.

  Raises `Ecto.NoResultsError` if the Breeder does not exist.

  ## Examples

      iex> get_breeder!(123)
      %Breeder{}

      iex> get_breeder!(456)
      ** (Ecto.NoResultsError)

  """
  def get_breeder!(id), do: Repo.get!(Breeder, id)

  @doc """
  Creates a breeder.

  ## Examples

      iex> create_breeder(%{field: value})
      {:ok, %Breeder{}}

      iex> create_breeder(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_breeder(attrs \\ %{}) do
    %Breeder{}
    |> Breeder.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a breeder.

  ## Examples

      iex> update_breeder(breeder, %{field: new_value})
      {:ok, %Breeder{}}

      iex> update_breeder(breeder, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_breeder(%Breeder{} = breeder, attrs) do
    breeder
    |> Breeder.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a breeder.

  ## Examples

      iex> delete_breeder(breeder)
      {:ok, %Breeder{}}

      iex> delete_breeder(breeder)
      {:error, %Ecto.Changeset{}}

  """
  def delete_breeder(%Breeder{} = breeder) do
    Repo.delete(breeder)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking breeder changes.

  ## Examples

      iex> change_breeder(breeder)
      %Ecto.Changeset{data: %Breeder{}}

  """
  def change_breeder(%Breeder{} = breeder, attrs \\ %{}) do
    Breeder.changeset(breeder, attrs)
  end
end
