defmodule DogBook.Data.DogImport do
  @doc """
  hXXXNN.txt is dog data -
  XXX: breed code.
  NN: serial number
  """
  alias DogBook.Data.Dog
  alias DogBook.Data
  alias DogBook.Meta
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
    18 => [:breeder, :number],
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

  def get_record(attr) do
    record = Data.get_record_registry_uid!(attr[:registry_uid])

    if is_nil(record) do
      {:ok, record} = Data.create_record(attr)
      record
    else
      record
    end
  end

  def to_cs_attrs(dog) do
    Enum.reduce(dog, %{}, fn {k, v}, acc ->
      cond do
        k == :birth_date and !is_nil(v) and v != "" ->
          year = String.slice(v, 0..3)
          month = String.slice(v, 4..5)
          day = String.slice(v, 6..7)
          Map.put(acc, k, Date.from_iso8601!("#{year}-#{month}-#{day}"))

        k == [:breed, :number] and !is_nil(v) and v != "" ->
          breed = DogBook.Meta.get_breed_number!(v)
          Map.put(acc, :breed_id, breed.id)

        k == [:record, :registry_uid] and !is_nil(v) and v != "" ->
          trimmed_v = String.trim(v, " ")
          record = get_record(%{registry_uid: trimmed_v})
          Map.put(acc, :records, [record])

        k == [:breeder, :number] and !is_nil(v) and v != "" ->
          breeder = Meta.get_breeder_number!(v)
          Map.put(acc, :breeder_id, breeder.id)

        k == [:color, :number] and !is_nil(v) and v != "" ->
          color = Meta.get_color_number!(v)
          Map.put(acc, :color_id, color.id)

        is_atom(k) and !is_nil(v) and v != "" ->
          Map.put(acc, k, v)

        true ->
          acc
      end
    end)
  end

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
    {:ok, result} = File.read(file_path)

    lines =
      :iconv.convert("cp852", "utf-8", result)
      |> String.split("\r")

    dogs =
      Enum.reduce(lines, [], fn line, acc ->
        [dog_read(line) | acc]
      end)

    attr_collection =
      Enum.reduce(dogs, [], fn dog, acc ->
        [to_cs_attrs(dog) | acc]
      end)
      |> Enum.filter(fn x -> !Enum.empty?(x) end)

    _dogs =
      Enum.reduce(attr_collection, [], fn dog_attr, acc ->
        record = dog_attr[:records] |> Enum.at(0)

        dog =
          if is_nil(record.dog_id) do
            cs = %Dog{} |> Dog.imperfect_changeset(dog_attr)

            if cs.valid? do
              DogBook.Repo.insert(cs)
            else
              %Dog{}
            end
          else
            dog = Data.get_dog!(record.dog_id)

            dog_attr =
              dog_attr
              |> Map.put(:records, dog_attr[:records] ++ dog.records)

            dog
            |> Dog.imperfect_changeset(dog_attr)
            |> DogBook.Repo.update()
          end

        [dog | acc]
      end)
  end
end
