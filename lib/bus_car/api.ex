defmodule BusCar.Api do
  require Logger
  alias BusCar.Request

  @cfg Application.get_env(:bus_car, :api)

  @protocol @cfg |> Dict.get(:protocol, "http")
  @host     @cfg |> Dict.get(:host)
  @port     @cfg |> Dict.get(:port)
  @headers  [{"Content-Type", "application/json"}]

  @default_map %{
    host:       @host,
    port:       @port,
    headers:    @headers,
    protocol:   @protocol,
  }

  def get(req,  opts \\ []), do: req |> Dict.put(:method, :get)  |> request(opts)
  def post(req, opts \\ []), do: req |> Dict.put(:method, :post) |> request(opts)
  def put(req,  opts \\ []), do: req |> Dict.put(:method, :put)  |> request(opts)

  def request(req, opts \\ [])
  def request(req, opts) when req |> is_list do
    req
    |> Enum.into(%{})
    |> request(opts)
  end
  def request(%Request{} = req, opts) do
    req
    |> Request.send(opts)
    |> handle_response(opts)
  end
  def request(%{} = map, opts) do
    @default_map
    |> Map.merge(map)
    |> Request.new
    |> request(opts)
  end

  defp handle_response(resp, opts) do
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
  defp do_handle_response({:error, %HTTPoison.Response{} = resp}) do
    Logger.error("Invalid Response\nGot: #{inspect resp}")
    case resp.body |> Poison.decode |> IO.inspect do
      {:ok, body} -> {:error, %{resp | body: body}}
      _           -> {:error, resp}
    end
  end
  defp do_handle_response({:error, reason}) do
    Logger.error("Invalid Response\nGot: #{inspect reason}")
    {:error, reason}
  end
  defp do_handle_response(x) do
    Logger.error("Unknown Response\nGot: #{inspect x}")
    {:error, x}
  end

  defp decode_body(%{body: body}) do
    body
    |> decode_body
  end
  defp decode_body(body) when body |> is_binary do
    body |> Poison.decode!
  end

end
