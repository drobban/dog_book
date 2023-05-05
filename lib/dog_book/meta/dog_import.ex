defmodule DogBook.Meta.DogImport do
  @doc """
  hXXXNN.txt is dog data -
  XXX: breed code.
  NN: serial number
  """
  @default_path 'priv/test_data/data/h12501.txt'

  # Check if we can work with ranges.
  @dog_format %{
    0 => [:breed, :number],
    1 => :dog_id,
    2 => :name,
    3 => :gender,
    4..9 => :championships,
    10 => :birth_date,
    11 => nil, #Breed specific data
    12 => :fur,
    13 => :size,
    14 => :observe,
    15 => :testicle_status,
    16 => :father_id,
    17 => :mother_id,
    18 => :breeder_id,
    19 => :color_number
  }

  def dog_read(line) do
    list = String.split(line, "\t")

    dog =
      Enum.reduce(@dog_format, %{},
        fn {idx, k}, acc ->
          cond do
            is_integer(idx) and !is_nil(k) ->
              Map.put(acc, k, Enum.at(list, idx))
            is_struct(idx) ->
              Map.put(acc, k,
                Enum.reduce(idx, [],
                  fn i, acc -> [Enum.at(list, i) | acc] end))
            true ->
              acc
          end
        end)

    dog
  end

  def process_dog(file_path \\ @default_path) do
    file_dev = File.open!(file_path, [:binary])
    result = IO.read(file_dev, :eof)

    lines =
      :iconv.convert("utf-8", "cp850",  result)
      |> String.split("\r")

    dogs = Enum.reduce(lines, [], fn line, acc ->
      [dog_read(line) | acc]
    end)

    dogs
  end
end
