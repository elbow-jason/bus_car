defmodule BusCar.Mixfile do
  use Mix.Project

  def project do
    [app: :bus_car,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  defp apps do
    [
      :logger,
      :httpoison,
    ]
  end

  def application do
    [
      applications: apps,
      mod: {BusCar, []},
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
    ]
  end
end
