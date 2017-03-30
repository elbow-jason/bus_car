defmodule TestRepo do
  use BusCar.Repo, otp_app: :test_example
end

defmodule BusCarRepoTest do
  use ExUnit.Case
  def exists?(mod) do
    :erlang.function_exported(mod, :module_info, 0)
  end

  test "Repo.Api is generated", do: assert exists?(TestRepo.Api)
  test "Repo.Config is generated", do: assert exists?(TestRepo.Config)
  
end