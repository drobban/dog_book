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

  def get_breed_number!(number), do: Repo.get_by!(Breed, number: number)

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

  def get_or_create_person(changeset) do
    attrs = changeset.changes
    # If we get a match - we assume it to be the same person.
    query =
      from p in Person,
        where: p.name == ^attrs[:name] and p.street == ^attrs[:street],
        select: p

    results =
      query
      |> Repo.all()

    cond do
      Enum.empty?(results) ->
        {:ok, person} = create_person(attrs)
        person

      true ->
        # Should only get one result, so no matter what - we take first.
        Enum.at(results, 0)
    end
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
    |> Repo.preload(:persons)
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
  def get_breeder!(id), do: Repo.get!(Breeder, id) |> Repo.preload(:persons)

  def get_breeder_number!(number), do: Repo.get_by!(Breeder, number: number)

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

  def update_or_create_breeder(attrs) do
    # If we get a match - we assume it to be the same person.
    query =
      from b in Breeder,
        where: b.number == ^attrs[:number],
        select: b

    results =
      query
      |> Repo.all()

    cond do
      Enum.empty?(results) ->
        {:ok, breeder} = create_breeder(attrs)
        breeder

      true ->
        # Should only get one result, so no matter what - we take first.
        breeder = get_breeder!(Enum.at(results, 0).id)
        update_breeder(breeder, attrs)
    end
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

  alias DogBook.Meta.Champion

  @doc """
  Returns the list of champions.

  ## Examples

      iex> list_champions()
      [%Champion{}, ...]

  """
  def list_champions do
    Repo.all(Champion)
  end

  @doc """
  Gets a single champion.

  Raises `Ecto.NoResultsError` if the Champion does not exist.

  ## Examples

      iex> get_champion!(123)
      %Champion{}

      iex> get_champion!(456)
      ** (Ecto.NoResultsError)

  """
  def get_champion!(id), do: Repo.get!(Champion, id)

  @doc """
  Creates a champion.

  ## Examples

      iex> create_champion(%{field: value})
      {:ok, %Champion{}}

      iex> create_champion(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_champion(attrs \\ %{}) do
    %Champion{}
    |> Champion.changeset(attrs)
    |> Repo.insert()
  end

  def update_or_create_champion(attrs) do
    # If we get a match - we assume it to be the same person.
    query =
      from c in Champion,
        where: c.number == ^attrs[:number],
        select: c

    results =
      query
      |> Repo.all()

    cond do
      Enum.empty?(results) ->
        {:ok, champion} = create_champion(attrs)
        champion

      true ->
        # Should only get one result, so no matter what - we take first.
        champion = get_champion!(Enum.at(results, 0).id)
        update_champion(champion, attrs)
    end
  end

  @doc """
  Updates a champion.

  ## Examples

      iex> update_champion(champion, %{field: new_value})
      {:ok, %Champion{}}

      iex> update_champion(champion, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_champion(%Champion{} = champion, attrs) do
    champion
    |> Champion.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a champion.

  ## Examples

      iex> delete_champion(champion)
      {:ok, %Champion{}}

      iex> delete_champion(champion)
      {:error, %Ecto.Changeset{}}

  """
  def delete_champion(%Champion{} = champion) do
    Repo.delete(champion)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking champion changes.

  ## Examples

      iex> change_champion(champion)
      %Ecto.Changeset{data: %Champion{}}

  """
  def change_champion(%Champion{} = champion, attrs \\ %{}) do
    Champion.changeset(champion, attrs)
  end

  alias DogBook.Meta.Color

  @doc """
  Returns the list of colors.

  ## Examples

      iex> list_colors()
      [%Color{}, ...]

  """
  def list_colors do
    Repo.all(Color)
  end

  @doc """
  Gets a single color.

  Raises `Ecto.NoResultsError` if the Color does not exist.

  ## Examples

      iex> get_color!(123)
      %Color{}

      iex> get_color!(456)
      ** (Ecto.NoResultsError)

  """
  def get_color!(id), do: Repo.get!(Color, id)

  def get_color_number!(number), do: Repo.get_by!(Color, number: number)

  @doc """
  Creates a color.

  ## Examples

      iex> create_color(%{field: value})
      {:ok, %Color{}}

      iex> create_color(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_color(attrs \\ %{}) do
    %Color{}
    |> Color.changeset(attrs)
    |> Repo.insert()
  end

  def update_or_create_color(attrs) do
    # If we get a match - we assume it to be the same person.
    query =
      from c in Color,
        where: c.number == ^attrs[:number],
        select: c

    results =
      query
      |> Repo.all()

    cond do
      Enum.empty?(results) ->
        {:ok, color} = create_color(attrs)
        color

      true ->
        # Should only get one result, so no matter what - we take first.
        color = get_color!(Enum.at(results, 0).id)
        update_color(color, attrs)
    end
  end

  @doc """
  Updates a color.

  ## Examples

      iex> update_color(color, %{field: new_value})
      {:ok, %Color{}}

      iex> update_color(color, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_color(%Color{} = color, attrs) do
    color
    |> Color.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a color.

  ## Examples

      iex> delete_color(color)
      {:ok, %Color{}}

      iex> delete_color(color)
      {:error, %Ecto.Changeset{}}

  """
  def delete_color(%Color{} = color) do
    Repo.delete(color)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking color changes.

  ## Examples

      iex> change_color(color)
      %Ecto.Changeset{data: %Color{}}

  """
  def change_color(%Color{} = color, attrs \\ %{}) do
    Color.changeset(color, attrs)
  end
end
