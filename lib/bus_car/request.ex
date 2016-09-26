defmodule BusCar.Request do
  alias BusCar.Request
  require Logger

  @json_headers [{"Content-Type", "application/json"}]
  @methods      [:get, :put, :post, :delete]

  defstruct [
    method:   nil,
    headers:  nil,
    protocol: nil,
    host:     nil,
    port:     nil,
    path:     nil,
    query:    nil,
    body:     nil,
  ]

  defp pretty_body("") do
    ":empty"
  end
  defp pretty_body(json) when json |> is_binary do
    case json |> Poison.decode do
      {:ok, map} -> map |> Poison.encode!(pretty: true)
      _          -> json
    end
  end
  defp pretty_body(x) do
    "#{inspect x}"
  end

  def send(%Request{method: method, body: body, headers: headers} = req, opts \\ []) when body |> is_binary do
    url = req |> Request.url
    Logger.debug("""

    ===> Sending Request ===> ===> ===>
    [MODULE]  #{__MODULE__}
    [METHOD]  #{inspect method}
    [URL]     #{inspect url}
    [HEADERS] #{inspect headers}
    [BODY]
    #{body |> pretty_body}
    [END]
    """)
    {status, resp} = HTTPoison.request(method, url, body, headers, opts)
    Logger.debug("""

    <=== Received Response <=== <=== <===
    [MODULE]  #{__MODULE__}
    [METHOD]  #{inspect method}
    [URL]     #{inspect url}
    [STATUS]  #{inspect status} #{resp |> Map.get(:status_code) |>  inspect}
    [RESPONSE BODY]
    #{resp |> Map.get(:body) |> pretty_body}
    [END]
    """)
    {status, resp}
  end

  def new(map \\ %{}) do
    # the order of these calls matters
    # so don't mess them up
    %Request{}
    |> assign(:body, map)
    |> assign(:method, map)
    |> assign(:headers, map)
    |> assign(:protocol, map)
    |> assign(:host, map)
    |> assign(:port, map)
    |> assign(:path, map)
    |> assign(:query, map)
  end

  def to_uri(%Request{} = req) do
    %URI{
      scheme: req.protocol,
      host:   req.host,
      port:   req.port,
      path:   req.path,
      query:  req.query,
    }
  end

  def url(%Request{} = req) do
    req
    |> to_uri
    |> to_string
  end

  #HEADLESS
  def assign(req, field, map \\ nil)
  #METHOD
  def assign(%Request{} = req, :method, %{method: method})  do
    assign(req, :method, method)
  end
  def assign(%Request{} = req, :method, method) when method in @methods do
    %{ req | method: method }
  end
  def assign(%Request{} = req, :method, _)  do
    assign(req, :method, :get)
  end
  #HEADERS
  def assign(%Request{headers: nil} = req, :headers, map) do
    assign(%{ req | headers: [] }, :headers, map)
  end
  def assign(%Request{} = req, :headers, %{headers: headers}) when headers |> is_list do
    assign(req, :headers, headers)
  end
  def assign(%Request{ headers: prev } = req, :headers, headers) when headers |> is_list do
    %{ req | headers: (prev ++ headers) |> Enum.uniq }
  end
  def assign(%Request{ headers: prev } = req, :headers, _) do
    %{ req | headers: prev |> Enum.uniq }
  end

  #PROTOCOL,
  def assign(%Request{} = req, :protocol, %{protocol: protocol}) do
    %{ req | protocol: protocol }
  end
  def assign(%Request{} = req, :protocol, _) do
    %{ req | protocol: "http" }
  end

  #HOST,
  def assign(%Request{} = req, :host, %{host: host}) do
    %{ req | host: host }
  end
  def assign(%Request{}, :host, _) do
    raise ":host required for requests"
  end

  #PORT
  def assign(%Request{} = req, :port, %{port: port}) do
    %{ req | port: port }
  end
  def assign(%Request{}, :port, _) do
    raise ":port required for requests"
  end


  #PATH
  def assign(%Request{} = req, :path, %{path: path}) do
    assign(%Request{} = req, :path, path)
  end
  def assign(%Request{} = req, :path, path) when path |> is_list do
    joined = path
      |> Enum.filter(fn item -> item end)
      |> Enum.map(&to_string/1)
      |> Path.join
    assign(%Request{} = req, :path, "/" <> joined)
  end
  def assign(%Request{} = req, :path, path) when path |> is_binary do
    %{ req | path: path }
  end
  def assign(%Request{} = req, :path, _) do
    assign(req, :path, "/")
  end
  #QUERY
  def assign(%Request{} = req, :query, %{query: query}) when query |> is_binary do
    %{ req | query: query }
  end
  def assign(%Request{} = req, :query, %{query: query}) when query |> is_map do
    assign(req, :query, %{query: query|> URI.encode_query})
  end
  def assign(%Request{} = req, :query, query) when query |> is_binary do
    %{ req | query: query }
  end
  def assign(%Request{} = req, :query, _ ) do
    %{ req | query: nil }
  end
  #BODY
  def assign(%Request{} = req, :body, %{body: body}) when body |> is_binary do
    %{ req | body: body }
  end
  def assign(%Request{} = req, :body, %{body: body}) when body |> is_map do
    %{ req | body: Poison.encode!(body), headers: @json_headers }
  end
  def assign(%Request{} = req, :body, %{body: body}) when body |> is_list do
    %{ req | body: Poison.encode!(body), headers: @json_headers }
  end
  def assign(%Request{} = req, :body, _)  do
    %{ req | body: "" }
  end

end

defimpl String.Chars, for: BusCar.Request do
  def to_string(%BusCar.Request{} = req) do
    req
    |> BusCar.Request.to_uri
    |> URI.to_string
  end
end
