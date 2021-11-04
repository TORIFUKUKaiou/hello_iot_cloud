defmodule HelloIotCloudWeb.ChartsLive do
  use HelloIotCloudWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    socket =
      socket
      |> assign(current_reading: 12)
      |> assign(time: format_time(Timex.now()))

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div id="charting">
      <h1>Temperature</h1>
      <div phx-update="ignore">
        <canvas id="chart-canvas-temperature"
                phx-hook="LineChart"
                data-chart-data="<%= Jason.encode!(%{suggestedmin: 0, suggestedmax: 45}) %>">
        </canvas>
      </div>
      <hr>
      <h1>Humidity</h1>
      <div phx-update="ignore">
        <canvas id="chart-canvas-humidity"
                phx-hook="LineChart"
                data-chart-data="<%= Jason.encode!(%{suggestedmin: 30, suggestedmax: 90}) %>">
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

    label = socket.assigns.time |> String.split(" ") |> Enum.at(1)
    names = Enum.map(users_with_last_value, & &1.name)

    temperature_points = %{
      id: "chart-canvas-temperature",
      label: label,
      values:
        Enum.map(users_with_last_value, & &1.values)
        |> Enum.map(&Enum.at(&1, 0))
        |> Enum.map(& &1.temperature),
      names: names
    }

    humidity_points = %{
      id: "chart-canvas-humidity",
      label: label,
      values:
        Enum.map(users_with_last_value, & &1.values)
        |> Enum.map(&Enum.at(&1, 0))
        |> Enum.map(& &1.humidity),
      names: names
    }

    push_event(socket, "new-points-points", %{
      temperature_points: temperature_points,
      humidity_points: humidity_points
    })
  end

  defp format_time(time) do
    HelloIotCloud.Cldr.format_time(time, locale: "ja-JP", timezone: "Asia/Tokyo")
  end
end
