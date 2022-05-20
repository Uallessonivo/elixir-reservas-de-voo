# Este teste é opcional, mas vale a pena tentar e se desafiar 😉

defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)
      Report.generate("report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end

  describe "generate/2" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when given from date and to date, return the content" do
      params = %{
        complete_date: ~N[2001-05-01 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      params2 = Map.put(params, :complete_date, ~N[2001-05-01 12:00:00])
      params3 = Map.put(params2, :complete_date, ~N[2001-05-01 12:00:00])

      Flightex.create_or_update_booking(params)
      Flightex.create_or_update_booking(params2)
      Flightex.create_or_update_booking(params3)

      content =
        "12345678900,Brasilia,Bananeiras,2001-05-01 12:00:00\n" <>
          "12345678900,Brasilia,Bananeiras,2001-05-01 12:00:00\n" <>
          "12345678900,Brasilia,Bananeiras,2001-05-01 12:00:00"

      {:ok, _msg} = Flightex.generate_report(~N[2001-05-01 12:00:00], ~N[2001-05-10 12:00:00])

      {:ok, file} = File.read("report.csv")

      assert file =~ content
    end
  end
end
