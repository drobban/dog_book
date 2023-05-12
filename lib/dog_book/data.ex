defmodule DogBook.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias DogBook.Repo

  alias DogBook.Data.Dog
  alias DogBook.Data.Record

  @doc """
  Returns the list of dogs.

  ## Examples

      iex> list_dogs()
      [%Dog{}, ...]

  """
  def list_dogs do
    Repo.all(Dog)
    |> Repo.preload([:parents, :records, :breed, :champions])
  end

  @doc """
  Gets a single dog.

  Raises `Ecto.NoResultsError` if the Dog does not exist.

  ## Examples

      iex> get_dog!(123)
      %Dog{}

      iex> get_dog!(456)
      ** (Ecto.NoResultsError)

  """
  def get_dog!(nil), do: nil

  def get_dog!(id),
    do: Repo.get!(Dog, id) |> Repo.preload([:parents, :records, :breed, :champions])

  @doc """
  Creates a dog.

  ## Examples

      iex> create_dog(%{field: value})
      {:ok, %Dog{}}

      iex> create_dog(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_dog(attrs \\ %{}) do
    # {status, dog} =
    %Dog{}
    |> Dog.changeset(attrs)
    |> Repo.insert()

    # {status, dog |> Repo.preload([:parents, :records, :breed])}
  end

  def create_partial_dog(attrs) do
    %Dog{}
    |> Dog.partial_parent(attrs)
    |> Repo.insert()
  end

  def get_or_create_parent(attrs) do
    # If we get a match - we assume it to be the same person.
    query =
      from r in Record,
        where: r.registry_uid == ^attrs[:registry_uid],
        select: r

    results =
      query
      |> Repo.all()

    cond do
      Enum.empty?(results) ->
        {:ok, record} = create_record(attrs)

        partial_dog =
          %{}
          |> Map.put(:partial, true)
          |> Map.put(:gender, attrs[:gender])
          |> Map.put(:breed_id, attrs[:breed_id])
          |> Map.put(:records, [record])

        create_partial_dog(partial_dog)

      true ->
        # Should only get one result, so no matter what - we take first.
        record = Enum.at(results, 0)
        IO.inspect(inspect(record))
        get_dog!(record.dog_id)
    end
  end

  @doc """
  Updates a dog.

  ## Examples

      iex> update_dog(dog, %{field: new_value})
      {:ok, %Dog{}}

      iex> update_dog(dog, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_dog(%Dog{} = dog, attrs) do
    dog
    |> Dog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a dog.

  ## Examples

      iex> delete_dog(dog)
      {:ok, %Dog{}}

      iex> delete_dog(dog)
      {:error, %Ecto.Changeset{}}

  """
  def delete_dog(%Dog{} = dog) do
    Repo.delete(dog)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dog changes.

  ## Examples

      iex> change_dog(dog)
      %Ecto.Changeset{data: %Dog{}}

  """
  def change_dog(%Dog{} = dog, attrs \\ %{}) do
    Dog.changeset(dog, attrs)
  end

  @doc """
  Returns the list of records.

  ## Examples

      iex> list_records()
      [%Record{}, ...]

  """
  def list_records do
    Repo.all(Record)
  end

  @doc """
  Gets a single record.

  Raises `Ecto.NoResultsError` if the Record does not exist.

  ## Examples

      iex> get_record!(123)
      %Record{}

      iex> get_record!(456)
      ** (Ecto.NoResultsError)

  """
  def get_record!(id), do: Repo.get!(Record, id)

  def get_record_registry_uid!(nil), do: nil

  def get_record_registry_uid!(uid) do
    # If we get a match - we assume it to be the same person.
    query =
      from r in Record,
        where: r.registry_uid == ^uid,
        select: r

    results =
      query
      |> Repo.all()

    if Enum.empty?(results), do: nil, else: Enum.at(results, 0)
  end

  def get_record_registry_uid_dog!(nil), do: nil

  def get_record_registry_uid_dog!(uid) do
    # If we get a match - we assume it to be the same person.
    query =
      from r in Record,
        where: r.registry_uid == ^uid and not is_nil(r.dog_id),
        select: r

    results =
      query
      |> Repo.all()

    if Enum.empty?(results), do: nil, else: Enum.at(results, 0)
  end

  @doc """
  Creates a record.

  ## Examples

      iex> create_record(%{field: value})
      {:ok, %Record{}}

      iex> create_record(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_record(attrs \\ %{}) do
    %Record{}
    |> Record.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a record.

  ## Examples

      iex> update_record(record, %{field: new_value})
      {:ok, %Record{}}

      iex> update_record(record, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_record(%Record{} = record, attrs) do
    record
    |> Record.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a record.

  ## Examples

      iex> delete_record(record)
      {:ok, %Record{}}

      iex> delete_record(record)
      {:error, %Ecto.Changeset{}}

  """
  def delete_record(%Record{} = record) do
    Repo.delete(record)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking record changes.

  ## Examples

      iex> change_record(record)
      %Ecto.Changeset{data: %Record{}}

  """
  def change_record(%Record{} = record, attrs \\ %{}) do
    Record.changeset(record, attrs)
  end
end
