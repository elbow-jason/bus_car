defmodule BusCar.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bus_car,
      version: "0.1.0",
      elixir: "~> 1.3",
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
    [# These are the default files included in the package
      name: :bus_car,
      files: ["lib", "mix.exs", "README*", "LICENSE*",],
      maintainers: ["Jason Goldberger"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/elbow-jason/bus_car",
      }
    ]
   end
  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.9.1"},
      {:poison, "~> 2.2"},
      {:ecto, "~> 2.0"},
      {:bus_car_dsl, "~> 0.1.2"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
