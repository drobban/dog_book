defmodule DogBook.Meta.BreederImport do
  @doc """
  uXXXNN.txt is breeder data -
  XXX: breed code.
  NN: serial number.
  """
  @default_path "priv/test_data/data/u12501.txt"

  @breeder_format %{
    0 => :number,
    1 => :name,
    (2..5) => %{persons: [:name, :street, :zip_code, :city]},
    (6..9) => %{persons: [:name, :street, :zip_code, :city]}
  }

  def breeder_read(line) do
    list = String.split(line, "\t")
    # breeder =
    Enum.reduce(@breeder_format, %{}, fn {idx, k}, acc ->
      cond  do
        is_integer(idx) and !is_nil(k) ->
          Map.put(acc, k, Enum.at(list, idx))
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
