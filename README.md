# BusCar

[![Build Status](https://travis-ci.org/elbow-jason/bus_car.svg?branch=master)](https://travis-ci.org/elbow-jason/bus_car)

**A super simple Elasticsearch tool with its own DSL and Ecto-like use.**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `bus_car` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:bus_car, "~> 0.1.0"}]
    end
    ```

  2. Ensure `bus_car` is started before your application:

    ```elixir
    def application do
      [applications: [:bus_car]]
    end
    ```

### Features/Goals/Wishes/Todos:

  - [x] Customizable Config
  - [x] Bool Dsl
  - [x] ConstantScore Dsl
  - [x] Exists Dsl
  - [x] Filter Dsl
  - [x] Match Dsl
  - [x] Query Dsl
  - [x] MustNot Dsl
  - [x] Must Dsl
  - [x] Nested Dsl
  - [x] Prefix Dsl
  - [x] Query Dsl
  - [x] Range Dsl
  - [x] Should Dsl
  - [x] Term Dsl
  - [ ] Functional Tests!
  - [ ] Geo Dsl
  - [ ] MoreLikeThis Query
  - [ ] Document to DSL to Requests pipeline
  - [ ] Ecto-ish Interface
  - [ ] Upsert
  - [ ] Hex.pm
