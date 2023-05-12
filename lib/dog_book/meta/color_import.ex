defmodule DogBook.Meta.ColorImport do
  @moduledoc """
  hfarg.txt contains all color codes there is to get.

  @color_format: for example look at BreederImport @breeder_format
  """

  alias DogBook.Meta.Color
  @default_path "priv/test_data/motherload/hfarg.txt"

  @color_format %{
    0 => :number,
    1 => :color
  }

  @spec color_read(char()) :: %Color{}
  def color_read(line) do
    list = String.split(line, "\t")

    color =
      Enum.reduce(@color_format, %{}, fn {idx, k}, acc ->
        if !is_nil(k) do
          Map.put(acc, k, Enum.at(list, idx))
        else
          acc
        end
      end)

    color_cs = Color.changeset(%Color{}, color)

    if color_cs.valid? do
      DogBook.Meta.update_or_create_color(color)
    else
      %Color{}
    end
  end

  @doc """
  This import is assumed to be performed before importing hXXXNN.txt.
  """
  def process_color(file_path \\ @default_path) do
    {:ok, result} = File.read(file_path)

    lines =
      :iconv.convert("cp852", "utf-8", result)
      |> String.split("\r\n")

    Enum.reduce(lines, [], fn line, acc ->
      [color_read(line) | acc]
    end)
  end
end
