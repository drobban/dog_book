defmodule DogBook.Data.DogImport do
  @doc """
  hXXXNN.txt is dog data -
  XXX: breed code.
  NN: serial number
  """
  alias DogBook.Data.Dog
  alias DogBook.Data
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

  def dog_changeset(attrs) do
    initialized_attrs =
      Enum.reduce(attrs, %{}, fn {k, v}, acc ->
        case k do
          [:breed, :number] ->
            if v == "" or is_nil(v) do
              Map.put(acc, :breed_id, nil)
            else
              breed = DogBook.Meta.get_breed_number!(v)
              Map.put(acc, :breed_id, breed.id)
            end

          [:breeder, :number] ->
            if v == "" or is_nil(v) do
              Map.put(acc, :breeder_id, nil)
            else
              breeder = DogBook.Meta.get_breeder_number!(v)
              Map.put(acc, :breeder_id, breeder.id)
            end

          [:parents, :father_id] when not is_nil(v) ->
            # parent_attrs = %{gender: :male, registry_uid: v}
            parent_attrs = %{gender: :male, registry_uid: v}
            parent = Dog.partial_parent(%Dog{}, parent_attrs)
            # parent = Data.get_or_create_parent(parent_attrs)
            parents = Map.get(acc, :parents, [])
            Map.put(acc, :parents, [parent | parents])

          [:parents, :mother_id] when not is_nil(v) ->
            # parent_attrs = %{gender: :female, registry_uid: v}
            parent_attrs = %{gender: :female, registry_uid: v}
            parent = Dog.partial_parent(%Dog{}, parent_attrs)
            # parent = Data.get_or_create_parent(parent_attrs)
            parents = Map.get(acc, :parents, [])
            Map.put(acc, :parents, [parent | parents])

          x when is_atom(x) ->
            Map.put(acc, x, v)

          _else ->
            acc
        end
      end)

    dog_cs = Dog.changeset(%Dog{}, initialized_attrs)

    [dog_cs, initialized_attrs]
    # if dog_cs.valid? do
    #   # Dog.create_dog(dog_cs.changes)
    #   dog_cs
    # else
    #   # initialized_attrs = initialized_attrs |> Map.put(:partial, true)
    #   # Dog.partial_parent(%Dog{}, initialized_attrs)
    #   initialized_attrs |> Map.put(:partial, true)
    # end
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

    Enum.reduce(dogs, [], fn dog, acc ->
      [dog_changeset(dog) | acc]
    end)
    |> Enum.at(50)
  end
end
