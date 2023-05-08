defmodule DogBook.DataTest do
  use DogBook.DataCase

  alias DogBook.Data

  describe "dogs" do
    alias DogBook.Data.Dog

    import DogBook.DataFixtures

    @invalid_attrs %{
      birth_date: nil,
      breed_specific: nil,
      coat: nil,
      gender: nil,
      name: nil,
      observe: nil,
      partial: nil,
      size: nil,
      testicle_status: nil
    }

    test "list_dogs/0 returns all dogs" do
      dog = dog_fixture()
      assert Data.list_dogs() == [dog]
    end

    test "get_dog!/1 returns the dog with given id" do
      dog = dog_fixture()
      assert Data.get_dog!(dog.id) == dog
    end

    test "create_dog/1 with valid data creates a dog" do
      valid_attrs = %{
        birth_date: ~D[2023-05-07],
        breed_specific: :bobtail,
        coat: :short,
        gender: :male,
        name: "some name",
        observe: true,
        partial: true,
        size: :normal,
        testicle_status: :ok
      }

      assert {:ok, %Dog{} = dog} = Data.create_dog(valid_attrs)
      assert dog.birth_date == ~D[2023-05-07]
      assert dog.breed_specific == :bobtail
      assert dog.coat == :short
      assert dog.gender == :male
      assert dog.name == "some name"
      assert dog.observe == true
      assert dog.partial == true
      assert dog.size == :normal
      assert dog.testicle_status == :ok
    end

    test "create_dog/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_dog(@invalid_attrs)
    end

    test "update_dog/2 with valid data updates the dog" do
      dog = dog_fixture()

      update_attrs = %{
        birth_date: ~D[2023-05-08],
        breed_specific: :docked,
        coat: :long,
        gender: :female,
        name: "some updated name",
        observe: false,
        partial: false,
        size: :dwarf,
        testicle_status: :cryptochid
      }

      assert {:ok, %Dog{} = dog} = Data.update_dog(dog, update_attrs)
      assert dog.birth_date == ~D[2023-05-08]
      assert dog.breed_specific == :docked
      assert dog.coat == :long
      assert dog.gender == :female
      assert dog.name == "some updated name"
      assert dog.observe == false
      assert dog.partial == false
      assert dog.size == :dwarf
      assert dog.testicle_status == :cryptochid
    end

    test "update_dog/2 with invalid data returns error changeset" do
      dog = dog_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_dog(dog, @invalid_attrs)
      assert dog == Data.get_dog!(dog.id)
    end

    test "delete_dog/1 deletes the dog" do
      dog = dog_fixture()
      assert {:ok, %Dog{}} = Data.delete_dog(dog)
      assert_raise Ecto.NoResultsError, fn -> Data.get_dog!(dog.id) end
    end

    test "change_dog/1 returns a dog changeset" do
      dog = dog_fixture()
      assert %Ecto.Changeset{} = Data.change_dog(dog)
    end
  end

  describe "records" do
    alias DogBook.Data.Record

    import DogBook.DataFixtures

    @invalid_attrs %{country: nil, registry_uid: nil}

    test "list_records/0 returns all records" do
      record = record_fixture()
      assert Data.list_records() == [record]
    end

    test "get_record!/1 returns the record with given id" do
      record = record_fixture()
      assert Data.get_record!(record.id) == record
    end

    test "create_record/1 with valid data creates a record" do
      valid_attrs = %{country: "some country", registry_uid: "some registry_uid"}

      assert {:ok, %Record{} = record} = Data.create_record(valid_attrs)
      assert record.country == "some country"
      assert record.registry_uid == "some registry_uid"
    end

    test "create_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_record(@invalid_attrs)
    end

    test "update_record/2 with valid data updates the record" do
      record = record_fixture()
      update_attrs = %{country: "some updated country", registry_uid: "some updated registry_uid"}

      assert {:ok, %Record{} = record} = Data.update_record(record, update_attrs)
      assert record.country == "some updated country"
      assert record.registry_uid == "some updated registry_uid"
    end

    test "update_record/2 with invalid data returns error changeset" do
      record = record_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_record(record, @invalid_attrs)
      assert record == Data.get_record!(record.id)
    end

    test "delete_record/1 deletes the record" do
      record = record_fixture()
      assert {:ok, %Record{}} = Data.delete_record(record)
      assert_raise Ecto.NoResultsError, fn -> Data.get_record!(record.id) end
    end

    test "change_record/1 returns a record changeset" do
      record = record_fixture()
      assert %Ecto.Changeset{} = Data.change_record(record)
    end
  end
end
