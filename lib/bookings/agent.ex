defmodule Flightex.Bookings.Agent do
  alias Flightex.Bookings.Booking

  use Agent

  def start_link(_initial_state) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Booking{} = booking) do
    uuid = UUID.uuid4()
    Agent.update(__MODULE__, fn state -> update_state(state, booking, uuid) end)

    {:ok, uuid}
  end

  def get(uuid), do: Agent.get(__MODULE__, fn state -> get_booking(state, uuid) end)

  def list_all, do: Agent.get(__MODULE__, & &1)

  defp get_booking(state, uuid) do
    case Map.get(state, uuid) do
      nil -> {:error, "Booking not found"}
      booking -> {:ok, booking}
    end
  end

  defp update_state(state, %Booking{} = booking, uuid), do: Map.put(state, uuid, booking)
end
