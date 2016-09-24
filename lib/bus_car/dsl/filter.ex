defmodule BusCar.Dsl.Filter do
  use BusCar.Dsl

  @key :filter

  list_rule(@key, :match)
  list_rule(@key, :term)
  list_rule(@key, :exists)
  list_rule(@key, :prefix)
  list_rule(@key, :wildcard)
  list_rule(@key, :range)
  list_rule(@key, :fuzzy)
  list_rule(@key, :regexp)

  map_rule(@key, :range)
  map_rule(@key, :match)
  map_rule(@key, :term)


end
