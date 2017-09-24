use Mix.Config

config :bus_car, :dev_example,
  headers: [{"x-bus_car-dev-example", "some_header"}],
  host: "localhost",
  port: 9200

