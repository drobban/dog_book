defmodule DogBook.Data.DogImport do
  @doc """
  hXXXNN.txt is dog data -
  XXX: breed code.
  NN: serial number
  """
  alias DogBook.Data.Dog
  alias DogBook.Data
  alias DogBook.Meta
  @default_path 'priv/test_data/motherload/h00001.txt'

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

  def parent_attrs(dog) do
    Enum.reduce(dog, %{}, fn {k, v}, acc ->
      cond do
        k == :birth_date and !is_nil(v) and v != "" ->
          year = String.slice(v, 0..3)
          month = String.slice(v, 4..5)
          day = String.slice(v, 6..7)
          {status, date} = Date.from_iso8601("#{year}-#{month}-#{day}")

          date =
            if status == :error do
              nil
            else
              date
            end

          Map.put(acc, k, date)

        k == [:parents, :father_id] and !is_nil(v) and v != "" ->
          Map.put(acc, k, v)

        k == [:parents, :mother_id] and !is_nil(v) and v != "" ->
          Map.put(acc, k, v)

        k == [:record, :registry_uid] and !is_nil(v) and v != "" ->
          Map.put(acc, :registry_uid, v)

        k == :name and !is_nil(v) and v != "" ->
          Map.put(acc, k, v)

        true ->
          acc
      end
    end)
  end

  def to_cs_attrs(dog) do
    Enum.reduce(dog, %{}, fn {k, v}, acc ->
      cond do
        k == :birth_date and !is_nil(v) and v != "" ->
          year = String.slice(v, 0..3)
          month = String.slice(v, 4..5)
          day = String.slice(v, 6..7)
          {status, date} = Date.from_iso8601("#{year}-#{month}-#{day}")

          date =
            if status == :error do
              nil
            else
              date
            end

          Map.put(acc, k, date)

        k == [:breed, :number] and !is_nil(v) and v != "" ->
          breed = DogBook.Meta.get_breed_number!(v)
          Map.put(acc, :breed_id, breed.id)

        k == [:record, :registry_uid] and !is_nil(v) and v != "" ->
          # Here we need to check dog name for existing dog.
          trimmed_v = String.trim(v, " ")
          record = get_record(%{registry_uid: trimmed_v})
          Map.put(acc, :records, [record])

        k == [:breeder, :number] and !is_nil(v) and v != "" ->
          breeder = Meta.get_breeder_number(v)
          id = if !is_nil(breeder), do: breeder.id, else: nil
          Map.put(acc, :breeder_id, id)

        k == [:color, :number] and !is_nil(v) and v != "" ->
          color = Meta.get_color_number(v)
          id = if !is_nil(color), do: color.id, else: nil
          Map.put(acc, :color_id, id)

        k == [:championships, :number] and !is_nil(v) ->
          champs =
            Enum.reduce(v, [], fn x, acc ->
              if x != "" and !is_nil(x) do
                number = if String.to_integer(x) > 2000, do: String.slice(x, -3, 3), else: x
                [Meta.get_champion_number!(number) | acc]
              else
                acc
              end
            end)

          champs = champs |> MapSet.new() |> MapSet.to_list()

          if Enum.empty?(champs) do
            acc
          else
            Map.put(acc, :champions, champs)
          end

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
      |> String.split("\r\n")

    dogs =
      Enum.reduce(lines, [], fn line, acc ->
        [dog_read(line) | acc]
      end)

    attr_collection =
      Enum.reduce(dogs, [], fn dog, acc ->
        [to_cs_attrs(dog) | acc]
      end)
      |> Enum.filter(fn x -> !Enum.empty?(x) end)

    Enum.reduce(attr_collection, [], fn dog_attr, acc ->
      record = dog_attr[:records] |> Enum.at(0)

      # Search for name...
      # If we find existing, update else insert.
      # If record.dog_id is nil. Set it to current dog.
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

          {:ok, _dog} =
            dog
            |> Dog.update_changeset(dog_attr)
            |> DogBook.Repo.update()
        end

      [dog | acc]
    end)

    attr_parents =
      Enum.reduce(dogs, [], fn dog, acc ->
        [parent_attrs(dog) | acc]
      end)
      |> Enum.filter(fn x -> !Enum.empty?(x) end)
      |> Enum.filter(fn x -> Map.has_key?(x, [:parents, :father_id]) end)

    dog_record_data =
      DogBook.Data.Record
      |> DogBook.Repo.all()
      |> DogBook.Repo.preload(:dog)
      |> Enum.reduce(%{}, fn dog_record, acc ->
        acc |> Map.put(dog_record.registry_uid, dog_record.dog)
      end)

    relations =
      Enum.reduce(attr_parents, [], fn e, acc ->
        father = dog_record_data |> Map.get(Map.get(e, [:parents, :father_id]), nil)
        mother = dog_record_data |> Map.get(Map.get(e, [:parents, :mother_id]), nil)
        child = dog_record_data |> Map.get(Map.get(e, :registry_uid), nil)

        [{father, mother, child} | acc]
      end)

    Enum.reduce(relations, [], fn {f, m, c}, acc ->
      if !is_nil(c) do
        parents =
          [f, m]
          |> Enum.filter(fn x -> !is_nil(x) end)
          |> Enum.reduce([], fn x, acc -> [x | acc] end)

        attrs = %{parents: parents}

        {:ok, child} =
          c
          |> Dog.parents_changeset(attrs)
          |> DogBook.Repo.update()

        [child | acc]
      else
        acc
      end
    end)
  end

  def setup() do
    DogBook.Meta.BreedImport.process_breed()
    DogBook.Meta.BreederImport.process_breeder()
    DogBook.Meta.ChampImport.process_champ()
    DogBook.Meta.ColorImport.process_color()

    DogBook.Data.DogImport.process_dog()
  end

  def bgf() do
    DogBook.Meta.BreederImport.process_breeder()
    DogBook.Meta.ChampImport.process_champ()
    DogBook.Meta.ColorImport.process_color()

    DogBook.Data.DogImport.process_dog()
  end
end
