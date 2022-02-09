defmodule HelloIotCloudWeb.API.RateLimitPlug do
  @moduledoc false

  import Plug.Conn, only: [put_status: 2, halt: 1]
  import Phoenix.Controller, only: [render: 2, put_view: 2]
  require Logger

  @doc """
  A function plug that does the rate limiting.

  ## Examples

      # In a controller
      import MnishiguchiWeb.API.RateLimitPlug, only: [rate_limit: 2]
      plug :rate_limit, max_requests: 5, interval_seconds: 10

  """
  def rate_limit(conn, opts \\ []) do
    case check_rate(conn, opts) do
      {:ok, _count} ->
        conn

      error ->
        Logger.info(rate_limit: error)
        render_error(conn)
    end
  end

  defp check_rate(conn, opts) do
    interval_ms = Keyword.fetch!(opts, :interval_seconds) * 1000
    max_requests = Keyword.fetch!(opts, :max_requests)

    ExRated.check_rate(bucket_name(conn), interval_ms, max_requests)
  end

  # Bucket name should be a combination of IP address and request path.
  defp bucket_name(conn) do
    path = "/" <> Enum.join(conn.path_info, "/")
    ip = conn.remote_ip |> Tuple.to_list() |> Enum.join(".")

    # E.g., "127.0.0.1:/api/v1/example"
    "#{ip}:#{path}"
  end

  defp render_error(conn) do
    # Using 503 because it may make attacker think that they have successfully DOSed the site.
    conn
    |> put_status(:service_unavailable)
    |> put_view(HelloIotCloudWeb.ErrorView)
    |> render(:"503")
    # Stop any downstream transformations.
    |> halt()
  end
end
