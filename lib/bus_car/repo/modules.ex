defmodule BusCar.Repo.Modules do

  def define_config(mod, otp_app) do
    contents = quote do
      use BusCar.Repo.Config, otp_app: unquote(otp_app)
    end
    name = BusCar.Repo.Helpers.concat_names(mod, Config)
    Module.create(name, contents, Macro.Env.location(__ENV__))
    name
  end

  def define_api(mod, otp_app) do
    contents = quote do
      use BusCar.Repo.Api, otp_app: unquote(otp_app)
    end
    name = BusCar.Repo.Helpers.concat_names(mod, Api)
    Module.create(name, contents, Macro.Env.location(__ENV__))
    name
  end

  def define_search(mod, api) do
    contents = quote do
      use BusCar.Repo.Search, api: unquote(api)
    end
    name = BusCar.Repo.Helpers.concat_names(mod, Search)
    Module.create(name, contents, Macro.Env.location(__ENV__))
    name
  end


end
