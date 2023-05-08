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
    1 => [:record, :registry_uid],
    2 => :name,
    3 => :gender,
    (4..9) => [:championships, :number],
    10 => :birth_date,
    11 => :breed_specific,
    12 => :coat,
    13 => :size,
    14 => :observe,
    15 => :testicle_status,
    16 => [:parents, :father_id],
    17 => [:parents, :mother_id],
    18 => [:breeder, :uid],
    19 => [:color, :number]
  }

  @gender_mappings %{"H" => :male, "T" => :female}
  @breed_specific_mappings %{"K" => :docked, "S" => :bobtail, "M" => :measured}
  @coat_mappings %{"K" => :short, "L" => :long, "S" => :broken}
  @size_mappings %{"N" => :normal, "D" => :dwarf, "K" => :rabbit}
  @observation_mappings %{"S" => true, "" => false}
  @testicle_mappings %{"G" => :ok, "K" => :cryptochid, "" => :unknown}

  @format_mappings %{
    3 => @gender_mappings,
    11 => @breed_specific_mappings,
    12 => @coat_mappings,
    13 => @size_mappings,
    14 => @observation_mappings,
    15 => @testicle_mappings
  }

  def dog_read(line) do
    list = String.split(line, "\t")

    # Format mappings is only used in the is_integer(idx) case.
    dog =
      Enum.reduce(@dog_format, %{}, fn {idx, k}, acc ->
        cond do
          is_integer(idx) and !is_nil(k) ->
            val =
              if Map.has_key?(@format_mappings, idx) do
                data_key = Enum.at(list, idx)
                @format_mappings[idx][data_key]
              else
                Enum.at(list, idx)
              end

            Map.put(acc, k, val)

          is_struct(idx) ->
            Map.put(acc, k, Enum.reduce(idx, [], fn i, acc -> [Enum.at(list, i) | acc] end))

          true ->
            acc
        end
      end)

    dog
  end

  @doc """
  When importing dogs, it will partially import parents based on the information provided
  with the current dog.

  When importing a new dog, we also need to check if a partial import already exist, if so
  we update that with more information.

  Before import of hXXXNN.txt can be imported the following files is expected;
  uXXXNN.txt, hfarg.txt, hchamp.txt, Hras.txt
  """
  def process_dog(file_path \\ @default_path) do
    file_dev = File.open!(file_path, [:binary])
    result = IO.read(file_dev, :eof)

    lines =
      :iconv.convert("utf-8", "cp850", result)
      |> String.split("\r")

    dogs =
      Enum.reduce(lines, [], fn line, acc ->
        [dog_read(line) | acc]
      end)

    dogs
  end
end
