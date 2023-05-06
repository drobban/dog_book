defmodule DogBook.Meta.BreederImport do
  @doc """
  uXXXNN.txt is breeder data -
  XXX: breed code.
  NN: serial number.
  """
  @default_path "priv/test_data/data/u12501.txt"

  @breeder_format %{
    0 => :number.
    1 => :name,
    2..2 => [:persons, :name],
    3..3 => [:persons, :street],
    4..4 => [:persons, :zip_code],
    5..5 => [:persons, :city],
    6..6 => [:persons, :name],
    7..7 => [:persons, :street],
    8..8 => [:persons, :zip_code],
    9..9 => [:persons, :city]
  }

end
