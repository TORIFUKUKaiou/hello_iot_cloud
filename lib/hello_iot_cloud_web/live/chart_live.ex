defmodule HelloIotCloudWeb.ChartLive do
  use HelloIotCloudWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :update)
    end

    socket =
      socket
      |> assign(
        chart_data: %{
          suggestedmin: 50,
          suggestedmax: 200
        }
      )
      |> assign(current_reading: 12)
      |> assign(time: format_time(Timex.now()))

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div id="charting">
      <h1>Title</h1>
      <div phx-update="ignore">
        <canvas id="chart-canvas"
                phx-hook="LineChart"
                data-chart-data="<%= Jason.encode!(@chart_data) %>">
        </canvas>
      </div>
      <div>
        Total readings: <%= @current_reading %>
      </div>
      <div>
        <%= @time %>
      </div>
    </div>
    """
  end

  def handle_info(:update, socket) do
    {:noreply, add_point(socket)}
  end

  defp add_point(socket) do
    socket = update(socket, :current_reading, &(&1 + 1))
    socket = assign(socket, time: format_time(Timex.now()))

    point = %{
      label: socket.assigns.current_reading,
      value: get_reading(),
      name: "user#{1..5 |> Enum.random()}"
    }

    push_event(socket, "new-point", point)
  end

  defp get_reading do
    Enum.random(70..180)
  end

  defp format_time(time) do
    HelloIotCloud.Cldr.format_time(time, locale: "ja-JP", timezone: "Asia/Tokyo")
  end
end
