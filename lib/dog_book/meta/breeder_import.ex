defmodule DogBook.Meta.BreederImport do
  @moduledoc """
  uXXXNN.txt is breeder data -
  XXX: breed code.
  NN: serial number.

  @breeder_format
  Map key: The key can be an integer or an range.
  A range assumes the input to be a set if Map value is a tuple
  If the Map value is a list or atom, it is assumed the input is a list.
  Map value: The value can be an atom, tuple or a list.
  An atom tells us that the input relate directly to our schema.
  An list of atoms declares the relation.
  An tuple assumes the Map key to be a range, the tuple gives us a declaration of relationship and the values that belongs. The tuple is helpful if the input contains a list of 'external' data that relates to our schema.

  private function map_read assumes the following;
  argument range & c depends upon each other and is also assumed
  to be of equal length. For each key in list c there should be a corrensponding idx in range.

  """
  @default_path "priv/test_data/data/u12501.txt"

  @breeder_format %{
    0 => :number,
    1 => :name,
    (2..6) => {:persons, [:name, :street, :zip_code, :city, :phone]},
    (7..11) => {:persons, [:name, :street, :zip_code, :city, :phone]}
  }

  defp map_read(nil, range, {_k, _c} = m, list), do: map_read([], range, m, list)

  defp map_read(acc, range, {_k, c} = _m, list) do
    fields = Enum.zip(range, c)

    data_map =
      Enum.reduce(fields, %{}, fn {idx, k}, acc ->
        acc
        |> Map.put(k, Enum.at(list, idx))
      end)

    [data_map | acc]
  end

  defp breeder_read(line) do
    list = String.split(line, "\t")

    Enum.reduce(@breeder_format, %{}, fn {idx, k}, acc ->
      cond do
        is_integer(idx) and !is_nil(k) ->
          Map.put(acc, k, Enum.at(list, idx))

        is_struct(idx) and is_tuple(k) ->
          {field_k, _c} = k
          Map.put(acc, field_k, map_read(acc[field_k], idx, k, list))

        true ->
          acc
      end
    end)
  end

  defp person_changesets(persons) do
    person_cs =
      Enum.reduce(persons, [], fn p, acc ->
        cs = DogBook.Meta.Person.changeset(%DogBook.Meta.Person{}, p)
        [cs | acc]
      end)

    person_cs
    |> Enum.filter(fn cs -> cs.valid? == true end)
  end

  defp breeder_update_or_insert(breeder) do
    {persons, breeder} = Map.pop(breeder, :persons)

    persons_cs = person_changesets(persons)

    breeder_cs = DogBook.Meta.Breeder.changeset(%DogBook.Meta.Breeder{}, breeder)

    cond do
      breeder_cs.valid? ->
        persons =
          Enum.reduce(persons_cs, [], fn p, acc ->
            [DogBook.Meta.get_or_create_person(p) | acc]
          end)

        breeder
        |> Map.put(:persons, persons)
        |> DogBook.Meta.update_or_create_breeder()

      true ->
        %DogBook.Meta.Breeder{}
    end
  end

  @doc """
  When importing breeders, it will create persons associated with the kennel.
  If a person with identical name and adress exist, a new relation will be created in the many_to_many table.

  This import is assumed to be performed before importing hXXXNN.txt.
  """
  def process_breeder(file_path \\ @default_path) do
    file_dev = File.open!(file_path, [:binary])
    result = IO.read(file_dev, :eof)

    lines =
      :iconv.convert("utf-8", "cp850", result)
      |> String.split("\r")

    breeders =
      Enum.reduce(lines, [], fn line, acc ->
        [breeder_read(line) | acc]
      end)

    Enum.reduce(breeders, [], fn b, acc ->
      [breeder_update_or_insert(b) | acc]
    end)
  end
end
