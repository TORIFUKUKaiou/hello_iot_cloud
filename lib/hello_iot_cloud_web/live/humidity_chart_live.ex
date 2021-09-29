defmodule HelloIotCloudWeb.HumidityChartLive do
  use HelloIotCloudWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    socket =
      socket
      |> assign(
        chart_data: %{
          suggestedmin: 30,
          suggestedmax: 90
        }
      )
      |> assign(current_reading: 12)
      |> assign(time: format_time(Timex.now()))

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div id="charting">
      <h1>Humidity</h1>
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

  def handle_info(:tick, socket) do
    socket = update(socket, :current_reading, &(&1 + 1))
    socket = assign(socket, time: format_time(Timex.now()))

    {:noreply, add_points(socket)}
  end

  defp add_points(socket) do
    users_with_last_value = HelloIotCloud.Accounts.list_with_last_value()

    points = %{
      label: socket.assigns.time |> String.split(" ") |> Enum.at(1),
      values:
        Enum.map(users_with_last_value, & &1.values)
        |> Enum.map(&Enum.at(&1, 0))
        |> Enum.map(& &1.humidity),
      names: Enum.map(users_with_last_value, & &1.name)
    }

    push_event(socket, "new-points", points)
  end

  defp format_time(time) do
    HelloIotCloud.Cldr.format_time(time, locale: "ja-JP", timezone: "Asia/Tokyo")
  end
end
