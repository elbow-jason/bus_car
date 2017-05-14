use Mix.Config

config :bus_car, :test_example,
  host: "localhost",
  port: 9200

config :slogger, BusCar.Request,
  level: :info