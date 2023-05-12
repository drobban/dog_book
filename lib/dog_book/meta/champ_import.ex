defmodule DogBook.Meta.ChampImport do
  @moduledoc """
  hchamp.txt contains all champ codes there is to get.

  @champ_format: for example look at BreederImport @breeder_format
  """

  alias DogBook.Meta.Champion
  @default_path "priv/test_data/motherload/hchamp.txt"

  @champ_format %{
    0 => :number,
    1 => :champ_name
  }

  @spec champ_read(char()) :: %Champion{}
  def champ_read(line) do
    list = String.split(line, "\t")

    champ =
      Enum.reduce(@champ_format, %{}, fn {idx, k}, acc ->
        if !is_nil(k) do
          Map.put(acc, k, Enum.at(list, idx))
        else
          acc
        end
      end)

    champ_cs = Champion.changeset(%Champion{}, champ)

    if champ_cs.valid? do
      DogBook.Meta.update_or_create_champion(champ)
    else
      %Champion{}
    end
  end

  @doc """
  This import is assumed to be performed before importing hXXXNN.txt.
  """
  def process_champ(file_path \\ @default_path) do
    {:ok, result} = File.read(file_path)

    lines =
      :iconv.convert("cp852", "utf-8", result)
      |> String.split("\r\n")

    Enum.reduce(lines, [], fn line, acc ->
      [champ_read(line) | acc]
    end)
  end
end
