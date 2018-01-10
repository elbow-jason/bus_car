defmodule BusCarTestRepo do
  use BusCar.Repo, otp_app: :test_example
end

defmodule BusCarRepoTestDoggy do
  use BusCar.Document

  document "testing_doggy", "repo_test_doggy" do
    property :name,       :string
    property :age,        :integer
    property :is_hairy,   :boolean, default: false
  end

  def changeset(model, changes) do
    model
    |> cast(changes, [:name, :age, :is_hairy])
    |> validate_required([:name])
  end
end

defmodule BusCarRepoTestKeyVal do
  use BusCar.Document

  document "testing_keyval", "repo_test_key_val" do
    property :key,       :keyword
    property :val,       :keyword
  end

  def changeset(model, changes) do
    model
    |> cast(changes, [:key, :val])
    |> validate_required([:key, :val])
  end
end

defmodule BusCarRepoTest do
  use ExUnit.Case
  alias BusCarTestRepo, as: Repo
  alias BusCarRepoTestDoggy, as: Doggy
  
  setup_all do
    Repo.delete_index(Doggy)
    Repo.put_mapping(Doggy)
    Repo.delete_index(BusCarRepoTestKeyVal)    
    Repo.put_mapping(BusCarRepoTestKeyVal)
    :ok
  end

  def exists?(mod) do
    :erlang.function_exported(mod, :module_info, 0)
  end

  def exists?(mod, fun, arity) do
    :erlang.function_exported(mod, fun, arity)
  end

  test "Repo is generated", do: assert exists?(Repo)
  test "Repo.Api is generated", do: assert exists?(Repo.Api)
  test "Repo.Cat is generated", do: assert exists?(Repo.Cat)
  test "Repo.Cluster is generated", do: assert exists?(Repo.Cluster)
  test "Repo.Config is generated", do: assert exists?(Repo.Config)
  test "Repo.Explain is generated", do: assert exists?(Repo.Explain)
  test "Repo.Index is generated", do: assert exists?(Repo.Index)
  test "Repo.Search is generated", do: assert exists?(Repo.Search)

  test "Repo.get/2 exists", do: assert exists?(Repo, :get, 2)
  test "Repo.get/3 exists", do: assert exists?(Repo, :get, 3)

  test "Repo.all/2 exists", do: assert exists?(Repo, :all, 2)
  test "Repo.all/3 exists", do: assert exists?(Repo, :all, 3)

  # test "Repo.get_by/2 exists", do: assert exists?(Repo, :get_by, 2)
  # test "Repo.get_by/3 exists", do: assert exists?(Repo, :get_by, 3)

  test "Repo.insert/1 exists", do: assert exists?(Repo, :insert, 1)
  test "Repo.insert/2 exists", do: assert exists?(Repo, :insert, 2)

  test "Repo.update/2 exists", do: assert exists?(Repo, :update, 2)
  
  test "Repo.delete/1 exists", do: assert exists?(Repo, :delete, 1)
  test "Repo.delete/2 exists", do: assert exists?(Repo, :delete, 2)
  test "Repo.delete/3 exists", do: assert exists?(Repo, :delete, 3)

  # test "Repo.get_by works" do
  #   name = "doggy-123" <> "-#{:rand.uniform}"
  #   inserted = Repo.insert(%Doggy{name: name})
  #   assert inserted.name == name
  #   found = Repo.get_by(Doggy, %{name: name})
  #   assert found != nil
  #   assert found.age == 1
  #   Repo.delete(found.id)
  # end

  test "Repo.insert inserts a new model" do
    my_dog =
      %Doggy{name: "fred", age: 1}
      |> BusCarTestRepo.insert
    assert !is_nil(my_dog.id)
    assert is_binary(my_dog.id)
    found = BusCarTestRepo.get(Doggy, my_dog.id)
    assert found.id == my_dog.id
  end

  test "Repo.update works" do
    my_dog =
      %Doggy{
        name: "fred",
        age: 1,
      }
      |> BusCarTestRepo.insert
    changes = %{name: "bread"}
    cs =
      my_dog
      |> BusCar.Changeset.cast(changes, [:name, :age])
      |> BusCar.Changeset.check_validity
    updated = BusCarTestRepo.update(cs)
    assert updated.name == "bread"
  end

  test "Repo.update does not insert when it should be updating" do
    my_dog = %Doggy{
      name: "fred",
      age: 1,
    } |> BusCarTestRepo.insert
    changes = %{name: "bread"}
    cs =
      my_dog
      |> BusCar.Changeset.cast(changes, [:name, :age])
      |> BusCar.Changeset.check_validity
    updated = BusCarTestRepo.update(cs)
    assert updated.id == my_dog.id
    loaded = BusCarTestRepo.get(Doggy, my_dog.id)
    assert loaded.id == my_dog.id
    assert loaded.id == updated.id
  end

  test "Repo.get_mapping works" do
    expected = %{
      "testing_doggy" => %{
        "mappings" => %{
          "repo_test_doggy" => %{
            "properties" => %{
              "name" => %{"type" => "text"},
              "age" => %{"type" => "integer"},
              "is_hairy" => %{"type" => "boolean"},
            }
          }
        }
      }
    }
    Repo.delete_index(Doggy)
    Repo.put_mapping(Doggy)
    assert Repo.get_mapping(Doggy) == expected
  end

  test "Repo.put_mapping works" do
    assert Repo.delete_index(Doggy) == %{"acknowledged" => true}
    assert Repo.put_mapping(Doggy)  == %{
      "acknowledged" => true,
      "shards_acknowledged" => true,
      "index" => "testing_doggy",
    }
  end

  test "Repo.insert works with a changeset" do
    c1 =
      %Doggy{}
      |> Doggy.changeset(%{"name" => "melbo", "age" => 10, "is_hairy" => true})
      |> Repo.insert
    assert c1.__struct__() == BusCarRepoTestDoggy
    assert c1.name == "melbo"
    assert c1.age == 10
    assert c1.is_hairy == true
    {:error, c2} =
      %Doggy{}
      |> Doggy.changeset(%{"age" => 10, "is_hairy" => true})
      |> Repo.insert
    assert c2.errors == [name: :cannot_be_blank]
  end

end

defmodule BusCarPaginationTest do
  use ExUnit.Case
  alias BusCarTestRepo, as: Repo
  alias BusCarRepoTestKeyVal, as: KeyVal

  setup_all do
    Repo.delete_index(KeyVal)
    # IO.puts("DELETED KEY VAL")
    :timer.sleep(200)
    # IO.puts("REMAPPING #{inspect KeyVal.mapping()}")
    Repo.put_mapping(KeyVal)
    # mapped = Repo.Api.get(path: "/testing_keyval/_mapping")
    # IO.puts("REMAPPED #{inspect mapped}")
    {:ok, %{}}
  end

  def insert_many(count) do
    1..count
    |> Enum.each(fn num ->
      %KeyVal{}
      |> KeyVal.changeset(%{"key" => "key_#{num}_of_#{count}", "val" => "#{num}"})
      |> Repo.insert
    end)
  end

  test "pagination works" do
    # Repo.put_mapping(KeyVal)
    assert insert_many(35) == :ok
    :timer.sleep(1000)
    found1 =
      KeyVal
      |> Repo.all([:size, 12, :from, 0, :sort, "val", :asc])
      |> Enum.map(fn item -> item.val end)
    found2 =
      KeyVal
      |> Repo.all([:size, 12, :from, 12, :sort, "val", :asc])
      |> Enum.map(fn item -> item.val end)
    found3 =
      KeyVal
      |> Repo.all([:size, 12, :from, 24, :sort, "val", :asc])
      |> Enum.map(fn item -> item.val end)
    found4 =
      KeyVal
      |> Repo.all([:size, 12, :from, 35, :sort, "val", :asc])
      |> Enum.map(fn item -> item.val end)
    
    assert length(found1) == 12
    assert length(found2) == 12
    assert length(found3) == 11
    assert length(found4) == 0
    found_set1 = MapSet.new(found1)
    found_set2 = MapSet.new(found2)
    in_common_1_2 = 
      MapSet.intersection(found_set1, found_set2)
      |> Enum.into([])
      |> length
    assert in_common_1_2 == 0
    assert found1 == ["1", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "2"]
  end
  
end