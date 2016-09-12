defmodule BusCar.Api do
  require Logger

  @cfg Application.get_env(:bus_car, :api)
  @host @cfg |> Dict.get(:host)
  @port @cfg |> Dict.get(:port)
  @protocol @cfg |> Dict.get(:protocol, "http")

  def host, do: @host
  def port, do: @port
  def protocol, do: @protocol

  def uri do
    %URI{
      host: @host,
      port: @port,
      scheme: @protocol,
    }
  end
  def uri(%{} = map) do
    uri
    |> Map.put(:query, Map.get(map, :query, nil))
    |> Map.put(:path, Map.get(map, :path, nil))
  end

  def get!(%{} = map, opts \\ []) do
    map
    |> uri
    |> to_string
    |> HTTPoison.get!
    |> handle_response(opts)
  end

  def put!(%{} = map, opts \\ []) do
    body = map
      |> encode_body
      |> Map.get(:body)
    map
    |> uri
    |> to_string
    |> HTTPoison.put!(body)
    |> handle_response(opts)
  end

  def handle_response(resp, opts \\ []) do
    cond do
      Dict.get(opts, :raw) == true  -> resp
      true                    -> resp |> do_handle_response
    end
  end
  defp do_handle_response(%{status_code: status} = resp) when status in 200..299 do
    resp
    |> decode_body
  end
  defp do_handle_response(x) do
    Logger.error("Invalid Response\nGot: #{inspect x}")
    x
  end

  def encode_body(%{body: body} = map) when body |> is_binary do
    map
  end
  def encode_body(%{body: body} = map) do
    map
    |> Map.put(:body, body |> Poison.encode!)
  end
  def encode_body(%{} = map) do
    map
    |> Map.put(:body, "")
  end

  def decode_body(%{body: body}) do
    body
    |> decode_body
  end
  def decode_body(body) when body |> is_binary do
    body |> Poison.decode!
  end


end
