defmodule DogBook.Meta.Import do
  alias DogBook.Meta.Breed
  @default_path "priv/test_data/temp2.txt"

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
    file_dev = File.open!(file_path)
    stream = IO.stream(file_dev, :line)

    breeds = Enum.reduce(stream, [], fn line, acc -> [breed_read(line) | acc] end)

    saved =
      for breed <- breeds do
        case breed do
          %{valid?: true} = changeset ->
            IO.inspect("Failed; #{changeset.changes.name}")

            changeset
            |> DogBook.Repo.insert!()

          %{valid?: false} = changeset ->
            IO.inspect("Failed; #{changeset.changes.name}")
            nil
        end
      end

    saved
  end
end
