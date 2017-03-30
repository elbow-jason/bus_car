defmodule BusCar.Repo.Modules do

  defmacro define_explain(mod) do
    quote do
      mod = unquote(mod)
      name = BusCar.Repo.Helpers.concat_names(mod, Explain)
      if !:erlang.function_exported(name, :module_info, 0) do
        # Module.create(name, contents, Macro.Env.location(__ENV__))
        defmodule name do
          use BusCar.Repo.Explain, repo: mod
        end
      end
    end
  end

  defmacro define_cluster(mod) do
    quote do
      mod = unquote(mod)
      name = BusCar.Repo.Helpers.concat_names(mod, Cluster)
      if !:erlang.function_exported(name, :module_info, 0) do
        # Module.create(name, contents, Macro.Env.location(__ENV__))
        defmodule name do
          use BusCar.Repo.Cluster, repo: mod
        end
      end
    end
  end

   defmacro define_index(mod) do
    quote do
      mod = unquote(mod)
      name = BusCar.Repo.Helpers.concat_names(mod, Index)
      if !:erlang.function_exported(name, :module_info, 0) do
        # Module.create(name, contents, Macro.Env.location(__ENV__))
        defmodule name do
          use BusCar.Repo.Index, repo: mod
        end
      end
    end
  end

  defmacro define_cat(mod) do
    quote do
      mod = unquote(mod)
      name = BusCar.Repo.Helpers.concat_names(mod, Cat)
      if !:erlang.function_exported(name, :module_info, 0) do
        # Module.create(name, contents, Macro.Env.location(__ENV__))
        defmodule name do
          use BusCar.Repo.Cat, repo: mod
        end
      end
    end
  end

  defmacro define_config(mod, otp_app) do
    quote do
      name = BusCar.Repo.Helpers.concat_names(unquote(mod), Config)
      if !:erlang.function_exported(name, :module_info, 0) do
        defmodule name do
          use BusCar.Repo.Config, otp_app: unquote(otp_app)
        end
      end
    end
  end

  defmacro define_api(mod, otp_app) do
    quote do
      name = BusCar.Repo.Helpers.concat_names(unquote(mod), Api)
      if !:erlang.function_exported(name, :module_info, 0) do
        defmodule name do
          use BusCar.Repo.Api, otp_app: unquote(otp_app)
        end
      end
    end
  end

  def define_search(mod) do
    quote do
      name = BusCar.Repo.Helpers.concat_names(unquote(mod), Search)
      if !:erlang.function_exported(name, :module_info, 0) do
        defmodule name do
          use BusCar.Repo.Search, repo: unquote(mod)
        end
      end
    end
  end

end
