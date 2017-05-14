defmodule BusCarTestRepo do
  use BusCar.Repo, otp_app: :test_example
end

defmodule BusCarRepoTestDoggy do
  use BusCar.Document

  document "test_animal", "test_dog_repo" do
    property :name,       :string
    property :age,        :integer
    property :is_hairy,   :boolean, default: false
  end

end
defmodule BusCarRepoTest do
  use ExUnit.Case
  alias BusCarTestRepo, as: Repo
  alias BusCarRepoTestDoggy, as: Doggy

  setup do
    Repo.delete_index(Doggy)
    Repo.put_mapping(Doggy)
    {:ok, %{}}
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

  test "Repo.get_mapping works" do
    assert Repo.get_mapping(Doggy) == %{"test_animal" => %{"mappings" => %{"test_dog_repo" => %{"properties" => %{"name" => %{"type" => "string"}, "age" => %{"type" => "integer"}, "is_hairy" => %{"type" => "boolean"}}}}}}
  end

  test "Repo.put_mapping works" do
    assert Repo.delete_index(Doggy) == %{"acknowledged" => true}
    assert Repo.put_mapping(Doggy)  == %{"acknowledged" => true}
  end

end
