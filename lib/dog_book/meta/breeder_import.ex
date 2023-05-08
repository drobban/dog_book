defmodule DogBook.Meta.BreederImport do
  @moduledoc """
  uXXXNN.txt is breeder data -
  XXX: breed code.
  NN: serial number.
  """
  @default_path "priv/test_data/data/u12501.txt"

  @breeder_format %{
    0 => :number,
    1 => :name,
    (2..6) => {:persons, [:name, :street, :zip_code, :city, :phone]},
    (7..11) => {:persons, [:name, :street, :zip_code, :city, :phone]}
  }

  @doc """
  argument range & c depends upon each other and is also assumed
  to be of equal length. For each key in list c there should be a corrensponding idx in range.
  """
  def map_read(nil, range, {_k, _c} = m, list), do: map_read([], range, m, list)

  def map_read(acc, range, {_k, c} = _m, list) do
    fields = Enum.zip(range, c)

    data_map =
      Enum.reduce(fields, %{}, fn {idx, k}, acc ->
        acc
        |> Map.put(k, Enum.at(list, idx))
      end)

    [data_map | acc]
  end

  def breeder_read(line) do
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

    breeders
  end
end
