defmodule DogBook.Meta.BreedImport do
  @doc """
  The original Hras.txt is encoded in cp865, this assumed to have been
  pre processed and stored as utf8 instead.

  Maybe cp850 is more correct to be used. Needs further investigation.
  """
  alias DogBook.Meta.Breed
  @default_path "priv/test_data/Hras.txt"

  @breed_format %{
    0 => :number,
    1 => :name
  }

  @spec breed_read(char()) :: %Breed{}
  def breed_read(line) do
    # line split into list according to breed_format
    list = String.split(line, "\t")

    breed =
      Enum.reduce(@breed_format, %{}, fn {idx, k}, acc ->
        if !is_nil(k) do
          Map.put(acc, k, Enum.at(list, idx))
        else
          acc
        end
      end)

    Breed.changeset(%Breed{}, breed)
  end

  def process_breed(file_path \\ @default_path) do
    {:ok, result} = File.read(file_path)

    lines =
      :iconv.convert("cp852", "utf-8", result)
      |> String.split("\r\n")

    breeds = Enum.reduce(lines, [], fn line, acc -> [breed_read(line) | acc] end)

    saved =
      for breed <- breeds do
        case breed do
          %{valid?: true} = changeset ->
            changeset
            |> DogBook.Repo.insert!()

          %{valid?: false} = _changeset ->
            nil
        end
      end

    saved
  end
end
