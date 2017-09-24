defmodule BusCar.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bus_car,
      version: "0.2.12",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),
   ]
  end

  defp apps do
    [
      :logger,
    ]
  end

  def application do
    [
      extra_applications: apps(),
      mod: {BusCar.Application, []},
    ]
  end

  defp description do
    """
    A super simple Elasticsearch tool with its own DSL and Ecto-like use.
    """
  end

  defp package do
    [
      name: :bus_car,
      files: ["lib", "mix.exs", "README*", "LICENSE*",],
      maintainers: ["Jason Goldberger"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/elbow-jason/bus_car",
      }
    ]
  end

  defp deps do
    [
      {:bus_car_dsl, "~> 0.1.4"},
      {:httpoison, "~> 0.9.1 or ~> 0.10.0 or ~> 0.11.0"},
      {:poison, "~> 2.0 or ~> 3.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:slogger, "~> 0.1.6"},
      {:gen_util, "~> 0.1.0"},
    ]
  end
end
