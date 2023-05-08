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

  describe "persons" do
    alias DogBook.Meta.Person

    import DogBook.MetaFixtures

    @invalid_attrs %{city: nil, name: nil, phone: nil, street: nil, zip_code: nil}

    test "list_persons/0 returns all persons" do
      person = person_fixture()
      assert Meta.list_persons() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert Meta.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      valid_attrs = %{city: "some city", name: "some name", phone: "some phone", street: "some street", zip_code: 42}

      assert {:ok, %Person{} = person} = Meta.create_person(valid_attrs)
      assert person.city == "some city"
      assert person.name == "some name"
      assert person.phone == "some phone"
      assert person.street == "some street"
      assert person.zip_code == 42
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meta.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()
      update_attrs = %{city: "some updated city", name: "some updated name", phone: "some updated phone", street: "some updated street", zip_code: 43}

      assert {:ok, %Person{} = person} = Meta.update_person(person, update_attrs)
      assert person.city == "some updated city"
      assert person.name == "some updated name"
      assert person.phone == "some updated phone"
      assert person.street == "some updated street"
      assert person.zip_code == 43
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = Meta.update_person(person, @invalid_attrs)
      assert person == Meta.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = Meta.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Meta.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = Meta.change_person(person)
    end
  end
end
