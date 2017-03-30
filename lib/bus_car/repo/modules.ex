defmodule BusCar.Repo.Modules do

  defmacro define_explain(mod) do
    quote do
      mod = unquote(mod)
      name = BusCar.Repo.Helpers.concat_names(mod, Explain)
      defmodule name do
        use BusCar.Repo.Explain, repo: mod
      end
    end
  end

  defmacro define_cluster(mod) do
    quote do
      mod = unquote(mod)
      name = BusCar.Repo.Helpers.concat_names(mod, Cluster)
      defmodule name do
        use BusCar.Repo.Cluster, repo: mod
      end
    end
  end

  defmacro define_index(mod) do
    quote do
      mod = unquote(mod)
      name = BusCar.Repo.Helpers.concat_names(mod, Index)
      defmodule name do
        use BusCar.Repo.Index, repo: mod
      end
    end
  end

  defmacro define_cat(mod) do
    quote do
      mod = unquote(mod)
      name = BusCar.Repo.Helpers.concat_names(mod, Cat)
      defmodule name do
        use BusCar.Repo.Cat, repo: mod
      end
    end
  end

  defmacro define_config(mod, otp_app) do
    quote do
      mod = unquote(mod)
      name = BusCar.Repo.Helpers.concat_names(mod, Config)
      defmodule name do
        use BusCar.Repo.Config, otp_app: unquote(otp_app)
      end
    end
  end

  defmacro define_api(mod, otp_app) do
    quote do
      mod = unquote(mod)
      name = BusCar.Repo.Helpers.concat_names(mod, Api)
      defmodule name do
        use BusCar.Repo.Api, otp_app: unquote(otp_app)
      end
    end
  end

  defmacro define_search(mod) do
    quote do
      mod = unquote(mod)
      name = BusCar.Repo.Helpers.concat_names(mod, Search)
      defmodule name do
        use BusCar.Repo.Search, repo: mod
      end
    end
  end

end
