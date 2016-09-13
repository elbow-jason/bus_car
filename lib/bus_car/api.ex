defmodule BusCar.Api do
  require Logger

  @cfg        Application.get_env(:bus_car, :api)
  @host       @cfg |> Dict.get(:host)
  @port       @cfg |> Dict.get(:port)
  @protocol   @cfg |> Dict.get(:protocol, "http")

  def host, do: @host
  def port, do: @port
  def protocol, do: @protocol

  @headers [{"Content-Type", "application/json"}]

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

  def get(%{} = map, opts \\ []),  do: request(map |> Map.put(:method, :get),  opts)
  def post(%{} = map, opts \\ []), do: request(map |> Map.put(:method, :post), opts)
  def put(%{} = map, opts \\ []),  do: request(map |> Map.put(:method, :put),  opts)

  def request(map, opts \\ [])
  def request(%{method: method, url: ""<>url, body: ""<>body, headers: headers}, opts) do
    HTTPoison.request(method, url, body, headers, opts)
    |> handle_response(opts)
  end
  def request(%{} = map, opts) do
    map
    |> prepare_map
    |> request(opts)
  end

  defp prepare_map(%{} = map) do
    map
    |> assign_url
    |> assign_method
    |> assign_headers
    |> encode_body
  end

  defp to_url(%{} = map) do
    map
    |> uri
    |> to_string
  end

  defp handle_response(resp, opts \\ []) do
    cond do
      Dict.get(opts, :raw) == true  -> resp
      true                          -> resp |> do_handle_response
    end
  end
  defp do_handle_response({:ok, resp}) do
    resp |> do_handle_response
  end
  defp do_handle_response(%{status_code: status} = resp) when status in 200..299 do
    resp
    |> decode_body
  end
  defp do_handle_response({:error, reason}) do
    Logger.error("Invalid Response\nGot: #{inspect reason}")
    {:error, reason}
  end
  defp do_handle_response(x) do
    Logger.error("Unknown Response\nGot: #{inspect x}")
    {:error, x}
  end

  defp assign_url(%{url: ""<>url} = map) do
    map
  end
  defp assign_url(%{} = map) do
    map |> Map.put(:url, map |> to_url)
  end

  defp assign_headers(%{headers: headers} = map) when headers |> is_list do
    map |> Map.put(:headers, headers ++ @headers)
  end
  defp assign_headers(%{} = map) do
    map |> Map.put(:headers, @headers)
  end

  defp assign_method(%{method: _} = map) do
    map
  end
  defp assign_method(%{} = map) do
    map |> Map.put(:method, :get)
  end

  defp encode_body(%{body: body} = map) when body |> is_binary do
    map
  end
  defp encode_body(%{body: body} = map) do
    map
    |> Map.put(:body, body |> Poison.encode!)
  end
  defp encode_body(%{} = map) do
    map
    |> Map.put(:body, "")
  end

  defp decode_body(%{body: body}) do
    body
    |> decode_body
  end
  defp decode_body(body) when body |> is_binary do
    body |> Poison.decode!
  end


end
