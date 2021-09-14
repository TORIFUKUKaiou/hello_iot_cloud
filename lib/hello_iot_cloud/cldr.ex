defmodule HelloIotCloud.Cldr do
  @default_locale "en"
  @default_timezone "UTC"
  @default_format :long

  use Cldr,
    locales: ["en", "ja"],
    default_locale: @default_locale,
    providers: [Cldr.Number, Cldr.Calendar, Cldr.DateTime]

  @doc """
  Formats datatime based on specified options.
  ## Examples
      iex> HelloIotCloud.Cldr.format_time(~U[2021-03-02 22:05:28Z], locale: "ja", timezone: "Asia/Tokyo")
      "2021年3月3日 7:05:28 JST"
      iex> HelloIotCloud.Cldr.format_time(~U[2021-03-02 22:05:28Z], locale: "ja", timezone: "America/New_York")
      "2021年3月2日 17:05:28 EST"
      iex> HelloIotCloud.Cldr.format_time(~U[2021-03-02 22:05:28Z], locale: "en-US", timezone: "America/New_York")
      "March 2, 2021 at 5:05:28 PM EST"
      # Fallback to ISO8601 string.
      iex> HelloIotCloud.Cldr.format_time(~U[2021-03-02 22:05:28Z], timezone: "Hello")
      "2021-03-02T22:05:28+00:00"
  """
  def format_time(datetime, options \\ []) do
    locale = options[:locale] || @default_locale
    timezone = options[:timezone] || @default_timezone
    format = options[:format] || @default_format

    with time_with_tz <- Timex.Timezone.convert(datetime, timezone),
         {:ok, formatted_time} <-
           HelloIotCloud.Cldr.DateTime.to_string(time_with_tz, locale: locale, format: format) do
      formatted_time
    else
      {:error, _reason} ->
        Timex.format!(datetime, "{ISO:Extended}")
    end
  end
end
