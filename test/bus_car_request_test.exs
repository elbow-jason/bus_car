defmodule BusCarRequestTest do
  use ExUnit.Case, async: true
  doctest BusCar.Request
  alias BusCar.Request

  @valid %{
    host: "beef",
    port: 4444,
  }

  test "Request.new raises without :host" do
    assert_raise RuntimeError, fn -> Request.new end
  end

  test "Request.new raises without :port" do
    assert_raise RuntimeError, fn -> Request.new(%{host: "beef"}) end
  end


  test "Request.new has sane defaults" do
    assert Request.new(@valid) == %BusCar.Request{
      body: "",
      headers: [],
      host: "beef",
      method: :get,
      path: "/",
      port: 4444,
      protocol: "http",
      query: nil,
    }
  end


  test "Request.new jsonifies map bodies" do
    map = Map.merge(@valid, %{body: %{some: :thing}})
    req = Request.new(map)
    assert req.body == ~s({"some":"thing"})
  end

  test "Request.new jsonifies map bodies and adds json headers" do
    map = Map.merge(@valid, %{body: %{some: :thing}})
    req = Request.new(map)
    assert req.body == ~s({"some":"thing"})
    assert req.headers == [{"Content-Type", "application/json"}]
  end

  test "protocol is configurable" do
    map = Map.merge(@valid, %{protocol: "https"})
    req = Request.new(map)
    assert req.protocol == "https"
  end

  test "headers are configurable" do
    map = Map.merge(@valid, %{headers: [{"fleep-x", "flop-x"}]})
    req = Request.new(map)
    assert req.headers == [{"fleep-x", "flop-x"}]
  end

  test "headers are configurable with json headers from map body" do
    map = Map.merge(@valid, %{headers: [{"fleep-x", "flop-x"}], body: %{"some" => "thing"}})
    req = Request.new(map)
    assert req.headers == [{"Content-Type", "application/json"}, {"fleep-x", "flop-x"}]
  end

  test "path can take a string" do
    map = Map.merge(@valid, %{path: "/fleep"})
    req = Request.new(map)
    assert req.path == "/fleep"
  end

  test "path can take a list of strings" do
    map = Map.merge(@valid, %{path: ["fleep", "floop"]})
    req = Request.new(map)
    assert req.path == "/fleep/floop"
  end

  test "path can take a list of atoms" do
    map = Map.merge(@valid, %{path: [:"fleep", :"floop"]})
    req = Request.new(map)
    assert req.path == "/fleep/floop"
  end

  test "path can take a list of mixed  strings and atoms" do
    map = Map.merge(@valid, %{path: ["fleep", :"floop"]})
    req = Request.new(map)
    assert req.path == "/fleep/floop"
  end

  test "path removes nil parts of a list" do
    map = Map.merge(@valid, %{path: [nil, "fleep", :"floop"]})
    req = Request.new(map)
    assert req.path == "/fleep/floop"
  end

  test "query can take a string" do
    map = Map.merge(@valid, %{query: "ryan=liar_about_boxing_gif"})
    req = Request.new(map)
    assert req.query == "ryan=liar_about_boxing_gif"
  end

  test "query can take a map" do
    map = Map.merge(@valid, %{query: %{"ryan" => "liar_about_boxing_gif", page: 2}})
    req = Request.new(map)
    assert req.query == "page=2&ryan=liar_about_boxing_gif"
  end

  test "implements String.Chars" do
    map = Map.merge(@valid, %{
      query: %{"ryan" => "liar_about_boxing_gif", page: 2},
      path: ["fleep", :floop],
    })
    expected = "http://beef:4444/fleep/floop?page=2&ryan=liar_about_boxing_gif"
    assert Request.new(map) |> to_string == expected
  end

  test "send works on localhost elasticsearch" do
    resp = %{host: "127.0.0.1", port: 9200, method: :get}
      |> Request.new
      |> Request.send
    assert resp |> elem(0) == :ok
    assert resp |> elem(1) |> Map.get(:status_code) == 200
  end

end
