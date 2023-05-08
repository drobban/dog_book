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
      valid_attrs = %{
        city: "some city",
        name: "some name",
        phone: "some phone",
        street: "some street",
        zip_code: 42
      }

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

      update_attrs = %{
        city: "some updated city",
        name: "some updated name",
        phone: "some updated phone",
        street: "some updated street",
        zip_code: 43
      }

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

  describe "breeders" do
    alias DogBook.Meta.Breeder

    import DogBook.MetaFixtures

    @invalid_attrs %{name: nil, number: nil}

    test "list_breeders/0 returns all breeders" do
      breeder = breeder_fixture()
      assert Meta.list_breeders() == [breeder]
    end

    test "get_breeder!/1 returns the breeder with given id" do
      breeder = breeder_fixture()
      assert Meta.get_breeder!(breeder.id) == breeder
    end

    test "create_breeder/1 with valid data creates a breeder" do
      valid_attrs = %{name: "some name", number: 42}

      assert {:ok, %Breeder{} = breeder} = Meta.create_breeder(valid_attrs)
      assert breeder.name == "some name"
      assert breeder.number == 42
    end

    test "create_breeder/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meta.create_breeder(@invalid_attrs)
    end

    test "update_breeder/2 with valid data updates the breeder" do
      breeder = breeder_fixture()
      update_attrs = %{name: "some updated name", number: 43}

      assert {:ok, %Breeder{} = breeder} = Meta.update_breeder(breeder, update_attrs)
      assert breeder.name == "some updated name"
      assert breeder.number == 43
    end

    test "update_breeder/2 with invalid data returns error changeset" do
      breeder = breeder_fixture()
      assert {:error, %Ecto.Changeset{}} = Meta.update_breeder(breeder, @invalid_attrs)
      assert breeder == Meta.get_breeder!(breeder.id)
    end

    test "delete_breeder/1 deletes the breeder" do
      breeder = breeder_fixture()
      assert {:ok, %Breeder{}} = Meta.delete_breeder(breeder)
      assert_raise Ecto.NoResultsError, fn -> Meta.get_breeder!(breeder.id) end
    end

    test "change_breeder/1 returns a breeder changeset" do
      breeder = breeder_fixture()
      assert %Ecto.Changeset{} = Meta.change_breeder(breeder)
    end
  end

  describe "champions" do
    alias DogBook.Meta.Champion

    import DogBook.MetaFixtures

    @invalid_attrs %{champ_name: nil, number: nil}

    test "list_champions/0 returns all champions" do
      champion = champion_fixture()
      assert Meta.list_champions() == [champion]
    end

    test "get_champion!/1 returns the champion with given id" do
      champion = champion_fixture()
      assert Meta.get_champion!(champion.id) == champion
    end

    test "create_champion/1 with valid data creates a champion" do
      valid_attrs = %{champ_name: "some champ_name", number: 42}

      assert {:ok, %Champion{} = champion} = Meta.create_champion(valid_attrs)
      assert champion.champ_name == "some champ_name"
      assert champion.number == 42
    end

    test "create_champion/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meta.create_champion(@invalid_attrs)
    end

    test "update_champion/2 with valid data updates the champion" do
      champion = champion_fixture()
      update_attrs = %{champ_name: "some updated champ_name", number: 43}

      assert {:ok, %Champion{} = champion} = Meta.update_champion(champion, update_attrs)
      assert champion.champ_name == "some updated champ_name"
      assert champion.number == 43
    end

    test "update_champion/2 with invalid data returns error changeset" do
      champion = champion_fixture()
      assert {:error, %Ecto.Changeset{}} = Meta.update_champion(champion, @invalid_attrs)
      assert champion == Meta.get_champion!(champion.id)
    end

    test "delete_champion/1 deletes the champion" do
      champion = champion_fixture()
      assert {:ok, %Champion{}} = Meta.delete_champion(champion)
      assert_raise Ecto.NoResultsError, fn -> Meta.get_champion!(champion.id) end
    end

    test "change_champion/1 returns a champion changeset" do
      champion = champion_fixture()
      assert %Ecto.Changeset{} = Meta.change_champion(champion)
    end
  end

  describe "colors" do
    alias DogBook.Meta.Color

    import DogBook.MetaFixtures

    @invalid_attrs %{color: nil, number: nil}

    test "list_colors/0 returns all colors" do
      color = color_fixture()
      assert Meta.list_colors() == [color]
    end

    test "get_color!/1 returns the color with given id" do
      color = color_fixture()
      assert Meta.get_color!(color.id) == color
    end

    test "create_color/1 with valid data creates a color" do
      valid_attrs = %{color: "some color", number: 42}

      assert {:ok, %Color{} = color} = Meta.create_color(valid_attrs)
      assert color.color == "some color"
      assert color.number == 42
    end

    test "create_color/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meta.create_color(@invalid_attrs)
    end

    test "update_color/2 with valid data updates the color" do
      color = color_fixture()
      update_attrs = %{color: "some updated color", number: 43}

      assert {:ok, %Color{} = color} = Meta.update_color(color, update_attrs)
      assert color.color == "some updated color"
      assert color.number == 43
    end

    test "update_color/2 with invalid data returns error changeset" do
      color = color_fixture()
      assert {:error, %Ecto.Changeset{}} = Meta.update_color(color, @invalid_attrs)
      assert color == Meta.get_color!(color.id)
    end

    test "delete_color/1 deletes the color" do
      color = color_fixture()
      assert {:ok, %Color{}} = Meta.delete_color(color)
      assert_raise Ecto.NoResultsError, fn -> Meta.get_color!(color.id) end
    end

    test "change_color/1 returns a color changeset" do
      color = color_fixture()
      assert %Ecto.Changeset{} = Meta.change_color(color)
    end
  end
end
