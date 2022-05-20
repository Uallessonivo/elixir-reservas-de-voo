defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(filename \\ "report-test.csv") do
    content =
      BookingAgent.list_all()
      |> Map.values()
      |> parse_values()

    File.write!(filename, content)
  end

  def generate_report(from_date, to_date) do
    filename = "report.csv"

    content =
      BookingAgent.list_all()
      |> Map.values()
      |> Enum.filter(&filter_by_date(&1, from_date, to_date))
      |> parse_values()

    with :ok <- File.write(filename, content) do
      {:ok, "Report generated successfully"}
    end
  end

  def filter_by_date(%Booking{complete_date: complete_date}, from_date, to_date) do
    Date.range(from_date, to_date)
    |> Enum.member?(NaiveDateTime.to_date(complete_date))
  end

  defp parse_values(values) do
    for %Booking{
          user_id: user_id,
          local_origin: local_origin,
          local_destination: local_destination,
          complete_date: complete_date
        } <- values do
      date_formatted = NaiveDateTime.to_string(complete_date)

      "#{user_id},#{local_origin},#{local_destination},#{date_formatted}\n"
    end
  end
end
