defmodule TestRepo do
  use BusCar.Repo, otp_app: :test_example
end

defmodule BusCarRepoTest do
  use ExUnit.Case

  def exists?(mod) do
    :erlang.function_exported(mod, :module_info, 0)
  end

  def exists?(mod, fun, arity) do
    :erlang.function_exported(mod, fun, arity)
  end

  test "Repo is generated", do: assert exists?(TestRepo)
  test "Repo.Api is generated", do: assert exists?(TestRepo.Api)
  test "Repo.Cat is generated", do: assert exists?(TestRepo.Cat)
  test "Repo.Cluster is generated", do: assert exists?(TestRepo.Cluster)
  test "Repo.Config is generated", do: assert exists?(TestRepo.Config)
  test "Repo.Explain is generated", do: assert exists?(TestRepo.Explain)
  test "Repo.Index is generated", do: assert exists?(TestRepo.Index)
  test "Repo.Search is generated", do: assert exists?(TestRepo.Search)

  test "Repo.get/2 exists", do: assert exists?(TestRepo, :get, 2)
  test "Repo.get/3 exists", do: assert exists?(TestRepo, :get, 3)

  test "Repo.all/2 exists", do: assert exists?(TestRepo, :all, 2)
  test "Repo.all/3 exists", do: assert exists?(TestRepo, :all, 3)

  test "Repo.get_by/2 exists", do: assert exists?(TestRepo, :get_by, 2)
  test "Repo.get_by/3 exists", do: assert exists?(TestRepo, :get_by, 3)

  test "Repo.insert/1 exists", do: assert exists?(TestRepo, :insert, 1)
  test "Repo.insert/2 exists", do: assert exists?(TestRepo, :insert, 2)

  test "Repo.update/2 exists", do: assert exists?(TestRepo, :update, 2)
  
  test "Repo.delete/1 exists", do: assert exists?(TestRepo, :delete, 1)
  test "Repo.delete/2 exists", do: assert exists?(TestRepo, :delete, 2)
  test "Repo.delete/3 exists", do: assert exists?(TestRepo, :delete, 3)

end

