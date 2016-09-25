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

  def get(req,  opts \\ []),    do: do_request(:get,    req, opts)
  def post(req, opts \\ []),    do: do_request(:post,   req, opts)
  def put(req,  opts \\ []),    do: do_request(:put,    req, opts)
  def delete(req,  opts \\ []), do: do_request(:delete, req, opts)

  defp do_request(method, req, opts) do
    req
    |> Dict.put(:method, method)
    |> request(opts)
  end

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
  defp do_handle_response(%{status_code: 404}) do
    {:error, :not_found}
  end
  defp do_handle_response(%{status_code: status} = resp) when status in 200..299 do
    with {:ok, body}  <- decode_body(resp),
          :ok         <- ensure_success(body),
         {:ok, hits}  <- get_hits(body)
    do
      hits
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp do_handle_response({:error, %HTTPoison.Response{} = resp}) do
    Logger.error("Invalid Response\nGot: #{inspect resp}")
    case resp.body |> Poison.decode do
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
    body |> decode_body
  end
  defp decode_body(body) when body |> is_binary do
    {:ok, body |> Poison.decode! }
  end

  defp get_hits(%{"hits" => h}) do
    get_hits(h)
  end
  defp get_hits(list) when list |> is_list do
    {:ok, list}
  end
  defp get_hits(map) when map |> is_map do
    {:ok, map}
  end
  defp get_hits(_) do
    {:error, :invalid_body}
  end

  defp ensure_success(%{"_shards" => %{"failed" => 0}}) do
    :ok
  end
  defp ensure_success(%{"found" => true}) do
    :ok
  end
  defp ensure_success(err) do
    {:error, err}
  end


end
