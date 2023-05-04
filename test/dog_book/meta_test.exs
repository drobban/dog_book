defmodule DogBook.MetaTest do
  use DogBook.DataCase

  alias DogBook.Meta

  describe "breeds" do
    alias DogBook.Meta.Breed

    import DogBook.MetaFixtures

    @invalid_attrs %{name: nil, number: nil}

    test "list_breeds/0 returns all breeds" do
      breed = breed_fixture()
      assert Meta.list_breeds() == [breed]
    end

    test "get_breed!/1 returns the breed with given id" do
      breed = breed_fixture()
      assert Meta.get_breed!(breed.id) == breed
    end

    test "create_breed/1 with valid data creates a breed" do
      valid_attrs = %{name: "some name", number: 42}

      assert {:ok, %Breed{} = breed} = Meta.create_breed(valid_attrs)
      assert breed.name == "some name"
      assert breed.number == 42
    end

    test "create_breed/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meta.create_breed(@invalid_attrs)
    end

    test "update_breed/2 with valid data updates the breed" do
      breed = breed_fixture()
      update_attrs = %{name: "some updated name", number: 43}

      assert {:ok, %Breed{} = breed} = Meta.update_breed(breed, update_attrs)
      assert breed.name == "some updated name"
      assert breed.number == 43
    end

    test "update_breed/2 with invalid data returns error changeset" do
      breed = breed_fixture()
      assert {:error, %Ecto.Changeset{}} = Meta.update_breed(breed, @invalid_attrs)
      assert breed == Meta.get_breed!(breed.id)
    end

    test "delete_breed/1 deletes the breed" do
      breed = breed_fixture()
      assert {:ok, %Breed{}} = Meta.delete_breed(breed)
      assert_raise Ecto.NoResultsError, fn -> Meta.get_breed!(breed.id) end
    end

    test "change_breed/1 returns a breed changeset" do
      breed = breed_fixture()
      assert %Ecto.Changeset{} = Meta.change_breed(breed)
    end
  end
end
