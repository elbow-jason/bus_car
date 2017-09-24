# BusCar

[![Build Status](https://travis-ci.org/elbow-jason/bus_car.svg?branch=master)](https://travis-ci.org/elbow-jason/bus_car)

**A super simple Elasticsearch tool with its own DSL and Ecto-like usage.**

## Usage

Make the Repo

```elixir
defmodule Example.Repo do
  use BusCar.Repo, opt_app: :some_example
end
```

Make a Mapping

```elixir
defmodule Example.Doge do
  use BusCar.Document

  document "animal", "dog" do
    property :name, :string
    property :age,  :integer

    timestamps
  end

end
```

Get all the Models (aliased names see `.iex.exs` for example)
```elixir
iex> Repo.all(Doge)
[
  %Example.Doge{_version: 1, age: 26, id: "33", inserted_at: "2016-09-26T02:34:20.187264Z", name: "Moe Moe", updated_at: "2016-09-26T02:34:20.187264Z"},
  %Example.Doge{_version: 1, age: 10, id: "AVdkWj0_-SwwFG-cHjcZ", inserted_at: "2016-09-26T02:36:58.044176Z", name: "Dora", updated_at: "2016-09-26T02:36:58.044176Z"}
]
```

Insert a few Models

```elixir
iex> Repo.insert(%Doge{name: "Daisy May", age: 18})
%Example.Doge{_version: 1, age: 18, id: "AVdkXSuf-SwwFG-cHjcd", inserted_at: "2016-09-26T02:40:10.140185Z", name: "Daisy May", updated_at: "2016-09-26T02:40:10.140185Z"}

iex> Repo.insert(%Doge{id: 10, name: "Punky", age: 35})
%Example.Doge{_version: 1, age: 35, id: "10", inserted_at: "2016-09-26T02:50:21.290414Z", name: "Punky", updated_at: "2016-09-26T02:50:21.290414Z"}
```

Go Bananas (Young Adult Doges only)

```elixir
iex> Repo.search(Doge, [:query, :bool, :must, :range, :age, :gte, 18, :lt, 30])
[
  %Example.Doge{_version: nil, age: 26, id: "33", inserted_at: "2016-09-26T02:34:20.187264Z", name: "Moe Moe", updated_at: "2016-09-26T02:34:20.187264Z"},
  %Example.Doge{_version: nil, age: 18, id: "AVdkXSuf-SwwFG-cHjcd", inserted_at: "2016-09-26T02:40:10.140185Z", name: "Daisy May", updated_at: "2016-09-26T02:40:10.140185Z"}
]
```



## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `bus_car` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:bus_car, "~> 0.2.12"}]
end
```

## Features/Todos

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
  - [x] Document to DSL to Requests pipeline
  - [x] Ecto-ish Interface
  - [x] Make sure Repo uses `:otp_app` keyword arg
  - [x] Request Tests
  - [x] Api Tests
  - [x] Repo Tests
  - [ ] Docs
  - [x] Mappings Tests
  - [ ] Github Repo for Example Project and Advanced Examples
  - [x] Optimistic "Locking" on update
  - [ ] Full Functional Tests
  - [ ] Geo Dsl
  - [ ] MoreLikeThis Query
  - [ ] Upsert
  - [x] Hex.pm
  - [ ] DB Connection Pooling?
  - [x] Extract BusCar DSL into its own Repo
