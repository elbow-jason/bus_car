defmodule BusCar.Repo.Api do

  defmacro __using__(opts) do
    quote do

      use Slogger, level: :info
      alias BusCar.Request

      opts = unquote(opts)
      if !opts do
        raise "BusCar.Repo.Api requires options. Got: #{inspect opts}"
      end
      @otp_app opts |> Keyword.get(:otp_app)
      if !@otp_app or !is_atom(@otp_app) do
        raise "When using BusCar.Repo `use BusCar.Repo, otp_app: <your_app_here>` syntax is required."
      end

      @cfg Application.get_env(:bus_car, @otp_app)
      if !@cfg do
        raise "BusCar.Repo.Api otp_app #{inspect @otp_app} is misconfigured"
      end

      @protocol @cfg |> Keyword.get(:protocol, "http")
      @host     @cfg |> Keyword.get(:host)
      @port     @cfg |> Keyword.get(:port)
      @headers  [{"Content-Type", "application/json"}]

      @default_map %{
        host:       @host,
        port:       @port,
        headers:    @headers,
        protocol:   @protocol,
      }

      def get(req, opts \\ []),    do: do_request(:get,    req, opts)
      def post(req, opts \\ []),   do: do_request(:post,   req, opts)
      def put(req, opts \\ []),    do: do_request(:put,    req, opts)
      def delete(req, opts \\ []), do: do_request(:delete, req, opts)

      defp do_request(method, req, opts) when req |> is_list do
        do_request(method, req |> Enum.into(%{}), opts)
      end
      defp do_request(method, req, opts) when req |> is_map do
        req
        |> Map.put(:method, method)
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
      def request(%{} = map,  opts) do
        @default_map
        |> Map.merge(map)
        |> Request.new
        |> request(opts)
      end

      defp handle_response(resp, opts) do
        cond do
          Keyword.get(opts, :raw_response) == true  -> resp
          true -> resp |> destructure_response
        end
      end

      defp destructure_response(response) do
        case response do
          {:ok, %{status_code: c} = resp} when c in 200..299 -> success(resp)
          {:error, err}   -> failure(err)
          {:ok, bad_resp} -> failure(bad_resp)
        end
      end

      defp failure({:error, err}) do
        failure(err)
      end
      defp failure(%{body: body}) do
        failure(body)
      end
      defp failure(%{reason: reason}) do
        {:error, reason}
      end
      defp failure(err) when err |> is_binary do
        case err |> Poison.decode do
          {:ok, json} ->
            Slogger.error("""
            [MODULE] #{__MODULE__}
            [ERROR]  API Response Error
            [REASON] #{inspect json}
            """)
            {:error, json}
          {:error, reason} ->
            Slogger.error("""
            [MODULE]      #{__MODULE__}
            [ERROR]       API Response Error
            [REASON]      Failure To Decode JSON
            [POISON ERR]  #{inspect reason}
            [RESPONSE]    #{inspect err}
            """)
            {:error, :invalid_response}
        end
      end

      defp success(resp) do
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
      defp ensure_success(resp) when resp |> is_map do
        # this clause may be too permissive.
        :ok
      end
      defp ensure_success(resp) when resp |> is_list do
        # this clause may be too permissive.
        :ok
      end
      defp ensure_success(err) do
        {:error, err}
      end
    end
  end
end
